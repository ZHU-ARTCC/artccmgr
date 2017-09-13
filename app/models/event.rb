class Event < ApplicationRecord
  has_many :controllers, class_name: 'Event::Controller'
  has_many :pilots, class_name: 'Event::Pilot'

  validates :name, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :start_time, presence: true, allow_blank: false, time: true
  validates :end_time, presence: true, allow_blank: false, time: true

end
