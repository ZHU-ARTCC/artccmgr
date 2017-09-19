class Event
  class Signup < ApplicationRecord
    belongs_to :event
    belongs_to :position, class_name: 'Event::Position'
    belongs_to :user

    validates :event, presence: true, allow_blank: false
    validates :position, presence: true, allow_blank: false
    validates :user, presence: true, allow_blank: false, uniqueness: { scope: [:event, :position] }
  end
end
