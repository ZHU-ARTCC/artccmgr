class Event
  class Controller < ApplicationRecord
    belongs_to :event
    belongs_to :position
    belongs_to :user, optional: true

    validates :event, presence: true, allow_blank: false
    validates :position, presence: true, allow_blank: false
  end
end
