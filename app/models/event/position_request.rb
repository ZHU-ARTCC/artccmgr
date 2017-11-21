# frozen_string_literal: true

class Event
  class PositionRequest < ApplicationRecord
    belongs_to :signup, class_name: 'Event::Signup'
    belongs_to :position, class_name: 'Event::Position'

    validates :signup, presence: true, allow_blank: false

    validates :position,
              presence: true,
              allow_blank: false,
              uniqueness: {
                scope: :signup
              }
  end
end
