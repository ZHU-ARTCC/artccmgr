class Event
  class Signup < ApplicationRecord
    belongs_to :event
    belongs_to :position, class_name: 'Event::Position'
    belongs_to :user

    has_many :requests, class_name: 'Event::PositionRequest'

    accepts_nested_attributes_for :requests, allow_destroy: true#, reject_if: lambda { |a| a[:position].blank? }
    validates_associated :requests

    validates :event, presence: true, allow_blank: false
    validates :user, presence: true, allow_blank: false, uniqueness: { scope: :event }

    validate :not_over

    private

    # Validates the event has not already ended
    def not_over
      unless event.nil?
        errors[:event] << 'is already over' unless event.end_time > Time.now
      end
    end
  end
end
