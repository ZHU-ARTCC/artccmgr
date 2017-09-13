class Event
  class Signup < ApplicationRecord
    belongs_to :event
    belongs_to :position, class_name: 'Event::Position'
    belongs_to :user

    validates :user, uniqueness: { scope: [:event, :position] }
  end
end
