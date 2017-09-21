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

    def callsign=(callsign)
      callsign.nil? ? super(callsign) : super(callsign.upcase)
    end

    private

    # Validates the user signing up for a pilot position is not
    # an active event controller
    def not_a_controller
      unless event.nil?
        errors[:user] << 'already controller in this event' unless event.event_positions.find_by(user: user).nil?
      end
    end

    # Validates the event has not already ended
    def not_over
      unless event.nil?
        errors[:event] << 'is already over' unless event.end_time > Time.now
      end
    end

  end
end
