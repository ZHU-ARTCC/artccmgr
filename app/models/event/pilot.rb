# frozen_string_literal: true

class Event
  class Pilot < ApplicationRecord
    belongs_to :event
    belongs_to :user

    validates :event, presence: true, allow_blank: false
    validates :callsign, presence: true, allow_blank: false
    validates :user, presence: true, allow_nil: false
    validates :user, uniqueness: { scope: :event, message: 'already signed up' }

    validate :not_a_controller
    validate :not_over

    # Determines whether a particular user has signed up for the event
    # as a pilot
    # Example: event.pilots.has_user?(User.first)
    #
    # rubocop:disable Style/PredicateName
    def self.has_user?(user)
      !joins(:user).where(user: user).empty?
    end
    # rubocop:enable Style/PredicateName

    # Formats the callsign to uppercase
    #
    def callsign=(callsign)
      callsign.nil? ? super(callsign) : super(callsign.upcase)
    end

    private

    # Validates the user signing up for a pilot position is not
    # an active event controller
    def not_a_controller
      return if event.nil?
      return if event.event_positions.find_by(user: user).nil?
      errors[:user] << 'already controller in this event'
    end

    # Validates the event has not already ended
    def not_over
      return if event.nil?
      errors[:event] << 'is already over' unless event.end_time > Time.now.utc
    end
  end
end
