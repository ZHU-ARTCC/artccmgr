class Event
  class Position < ApplicationRecord
    belongs_to :event
    belongs_to :user, optional: true

    has_many :signups

    validates :event, presence: true, allow_blank: false
    validates :callsign, presence: true, allow_blank: false, uniqueness: { scope: :event, case_sensitive: false, message: 'already assigned to event' }
    validates :user, uniqueness: { scope: :event, message: 'already assigned', allow_nil: true }

    validate :not_a_pilot

    private

    # Validates the user signing up for a controller position is not
    # an event pilot
    def not_a_pilot
      unless event.nil?
        errors[:user] << 'already pilot in this event' unless event.pilots.find_by(user: user).nil?
      end
    end
  end
end
