require 'vatsim'

class VatsimOnlineJob < ApplicationJob
  queue_as :default

  def perform(data_time = nil, update_time = nil)
    # Time objects cannot be serialized - convert back from string
    data_time   = Time.parse(data_time) unless data_time.nil?
    update_time = Time.parse(update_time) unless update_time.nil?

    # if last_data and update_interval are nil this a new app start
    if (data_time.nil? || update_time.nil?) || update_time < Time.now
      Rails.logger.debug 'VatsimOnlineJob: Downloading current information'
      online_data = download
      return if online_data.nil?
    else
      # In theory it should never hit this but if it does
      # (due to time sync issues) we'll wait 30 seconds
      new_update_time = update_time + 30.seconds
      Rails.logger.info "VatsimOnlineJob: Not time for update. Rescheduling for #{new_update_time}"
      VatsimOnlineJob.set(wait_until: new_update_time).perform_later(data_time.to_s, new_update_time.to_s)
      return
    end

    data_time         = online_data.general.update
    update_interval   = online_data.general.reload.minutes
    update_time       = data_time + update_interval

    parse_atc(online_data.atc)

    # Enqueue the next update job
    VatsimOnlineJob.set(wait_until: update_time).perform_later(data_time.to_s, update_time.to_s)
    Rails.logger.debug "VatsimOnlineJob: Next scheduled update at: #{update_time}"
    true
  end

  private

  # Download the latest VATSIM online users into a new
  # VATSIM::Data object
  #
  def download
    # Attempt to get new data servers if none exist
    get_new_data_servers if Vatsim::Dataserver.all.empty?

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

  # Download new data servers
  #
  # Updates entries in the Vatsim::Dataservers table
  #
  def get_new_data_servers
    begin
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
  end

  # Parse ATC positions for known positions and save to DB
  #
  def parse_atc(controllers)
    # Array CIDs of users on our roster to look for
    users = User.all.pluck :cid

    controllers.each do |c|
      next unless users.include? c.cid.to_i

      callsign_search = c.callsign.split('_')[0]

      user      = User.find_by(cid: c.cid.to_i)
      rating    = Rating.find_by(number: c.rating.to_i)
      position  = Position.where(frequency: c.frequency).where('callsign LIKE (?)', "#{callsign_search}_%").first

      if !user.nil? && !rating.nil? && !position.nil?
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
        entry.last_seen = Time.now
        entry.save
      end
    end
  end # def parse_atc

end
