class Event
  class Pilot < ApplicationRecord
    belongs_to :event
    belongs_to :user

    validates :event, presence: true, allow_blank: false
    validates :user, presence: true, allow_nil: false
    validates :user, uniqueness: { scope: :event, message: 'already signed up' }

    validate :not_a_controller

    private

    # Validates the user signing up for a pilot position is not
    # an active event controller
    def not_a_controller
      unless event.nil?
        errors[:user] << 'already controller in this event' unless event.positions.find_by(user: user).nil?
      end
    end

  end
end
