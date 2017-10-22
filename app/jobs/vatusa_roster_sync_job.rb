require 'vatusa'

class VatusaRosterSyncJob < ApplicationJob
  queue_as :default

  def perform(*args)
    url = Rails.application.secrets.vatusa_api_url
    key = Rails.application.secrets.vatusa_api_key

    @api = VATUSA::API.new(url, key)

    begin
      roster = @api.roster
      process_roster(roster.members)
      sync_staff(roster)
    rescue => e
      Rails.logger.error "VatusaRosterSyncJob: #{e}"
    end
  end

  private

  # Process the API response array
  #
  def process_roster(members)
    members.each do |member|
      user = User.find_or_initialize_by(cid: member.cid.to_i)

      user.name_first = member.fname
      user.name_last  = member.lname
      user.email      = member.email
      user.rating     = Rating.find_by(number: member.rating.to_i)
      user.reg_date   = Time.now if user.reg_date.nil?
      user.group      = Group.find_by(name: 'Controller')

      user.save if user.changed?
    end
  end

  # Synchronize staff members with VATUSA
  #
  def sync_staff(roster)
    if roster.id == Settings.artcc_icao
      %w{atm datm ta ec wm fe}.each do |position|
        user = User.find_by(cid: roster.send(position.to_sym).to_i)
        unless user.nil?
          case position
            when 'atm'
              user.group = Group.find_by(name: 'Air Traffic Manager')
            when 'datm'
              user.group = Group.find_by(name: 'Deputy Air Traffic Manager')
            when 'ta'
              user.group = Group.find_by(name: 'Training Administrator')
            when 'wm'
              user.group = Group.find_by(name: 'Webmaster')
            when 'fe'
              user.group = Group.find_by(name: 'Facility Engineer')
          end

          user.save if user.changed?
        end
      end
    else
      raise StandardError, 'Roster ICAO did not match ARTCC ICAO'
    end
  end

end
