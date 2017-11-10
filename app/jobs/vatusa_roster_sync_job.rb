require 'vatusa'

class VatusaRosterSyncJob < ApplicationJob
  queue_as :default

  def perform(*args)
    url = Rails.application.secrets.vatusa_api_url
    key = Rails.application.secrets.vatusa_api_key

    @api = VATUSA::API.new(url, key)

    begin
      roster = @api.roster

      if !roster.nil?
        process_roster(roster.members)
        sync_staff(roster)
      else
        raise StandardError, 'Roster returned an empty response'
      end
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

      # Do not change groups if they were already assigned
      # except for the Guest role or if they are a new user
      if user.persisted?
        if user.group == Group.find_by(name: 'Guest')
          user.group = Group.find_by(name: 'Controller')
        end
      else # brand new users created by roster API
        user.group = Group.find_by(name: 'Controller')
      end

      user.save if user.changed?
    end
  end

  # Synchronize staff members with VATUSA
  #
  def sync_staff(roster)
    roster.staff.to_h.each_pair do |position, members|
      users = members.collect{|m| User.find_by(cid: m.cid)}

      case position
        when :atm
          users.each{|u| u.group = Group.find_by(name: 'Air Traffic Manager')}
        when :datm
          users.each{|u| u.group = Group.find_by(name: 'Deputy Air Traffic Manager')}
        when :ta
          users.each{|u| u.group = Group.find_by(name: 'Training Administrator')}
        when :wm
          users.each{|u| u.group = Group.find_by(name: 'Webmaster')}
        when :fe
          users.each{|u| u.group = Group.find_by(name: 'Facility Engineer')}
      end

      users.each{|u| u.save if u.changed?}
    end
  end

end
