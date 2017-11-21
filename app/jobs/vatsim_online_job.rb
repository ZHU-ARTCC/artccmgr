# frozen_string_literal: true

require 'vatsim'

class VatsimOnlineJob < ApplicationJob
  queue_as :default

  # TODO: Refactor perform method
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  # rubocop:disable Metrics/LineLength, Metrics/MethodLength
  def perform(data_time = nil, update_time = nil)
    # Time objects cannot be serialized - convert back from string
    data_time   = Time.parse(data_time).utc unless data_time.nil?
    update_time = Time.parse(update_time).utc unless update_time.nil?

    # if last_data and update_interval are nil this a new app start
    if (data_time.nil? || update_time.nil?) || update_time < Time.now.utc
      Rails.logger.debug 'VatsimOnlineJob: Downloading current information'
      online_data = download
      return if online_data.nil?
    else
      # In theory it should never hit this but if it does
      # (due to time sync issues) we'll wait 30 seconds
      new_update_time = update_time + 30.seconds
      msg = "VatsimOnlineJob: Not time for update. Rescheduling at #{new_update_time}"
      Rails.logger.info msg

      VatsimOnlineJob.set(
        wait_until: new_update_time
      ).perform_later(data_time.to_s, new_update_time.to_s)
      return
    end

    data_time         = online_data.general.update
    update_interval   = online_data.general.reload.minutes
    update_time       = data_time + update_interval

    parse_atc(online_data.atc)

    # Enqueue the next update job
    VatsimOnlineJob.set(
      wait_until: update_time
    ).perform_later(data_time.to_s, update_time.to_s)

    msg = "VatsimOnlineJob: Next scheduled update at: #{update_time}"
    Rails.logger.debug msg
    true
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  # rubocop:enable Metrics/LineLength, Metrics/MethodLength

  private

  # Download the latest VATSIM online users into a new
  # VATSIM::Data object
  #
  # rubocop:disable Metrics/LineLength, Metrics/MethodLength
  def download
    # Attempt to get new data servers if none exist
    retrieve_new_data_servers if Vatsim::Dataserver.all.empty?

    # If it is still empty abort the download
    if Vatsim::Dataserver.all.empty?
      Rails.logger.error 'VatsimOnlineJob: No data servers available. Skipping Download'
      return nil
    end

    # Attempt to download data from random data servers
    begin
      retries ||= 0

      dataserver = Vatsim::Dataserver.order('RANDOM()').limit(1).first
      data       = VATSIM::Data.new(dataserver.url)
    rescue => e
      retries += 1
      Rails.logger.info "VatsimOnlineJob: Unable to download VATSIM status. Attempt #{retries} of 3: #{e}"
      retry if retries < 3
      Rails.logger.error "VatsimOnlineJob: Unable to download VATSIM status #{e}"
      return nil
    end

    data
  end
  # rubocop:enable Metrics/LineLength, Metrics/MethodLength

  # Download new data servers
  #
  # Updates entries in the Vatsim::Dataservers table
  #
  # rubocop:disable Metrics/LineLength
  def retrieve_new_data_servers
    retries ||= 0

    # Flush data servers out
    Vatsim::Dataserver.destroy_all

    VATSIM::Status.new(Settings.vatsim_status_url).data.each do |server|
      Vatsim::Dataserver.create(url: server)
    end
  rescue => e
    retries += 1
    Rails.logger.info "VatsimOnlineJob: Unable to get new data servers. Attempt #{retries} of 3: #{e}"
    sleep(5.seconds)
    retry if retries < 3
    Rails.logger.error "VatsimOnlineJob: Unable to retrieve VATSIM data servers: #{e}"
  end
  # rubocop:enable Metrics/LineLength

  # Parse ATC positions for known positions and save to DB
  #
  # TODO: Refactor to simpler method
  # rubocop:disable Metrics/MethodLength
  def parse_atc(controllers)
    # Array CIDs of users on our roster to look for
    users = User.all.pluck :cid

    controllers.each do |c|
      next unless users.include? c.cid.to_i

      callsign_search = c.callsign.split('_')[0]

      user      = User.find_by(cid: c.cid.to_i)
      rating    = Rating.find_by(number: c.rating.to_i)
      position  = Position.where(frequency: c.frequency)
                          .where('callsign LIKE (?)', "#{callsign_search}_%")
                          .first

      next unless !user.nil? && !rating.nil? && !position.nil?
      entry = Vatsim::Atc.find_or_initialize_by(
        position:   position,
        rating:     rating,
        user:       user,
        callsign:   c.callsign,
        frequency:  c.frequency,
        server:     c.server,
        logon_time: c.logon_time
      )

      # Add additional attributes that could possibly change
      entry.latitude  = c.latitude
      entry.longitude = c.longitude
      entry.range     = c.range
      entry.last_seen = Time.now.utc
      entry.save
    end
  end # def parse_atc
  # rubocop:enable Metrics/MethodLength
end
