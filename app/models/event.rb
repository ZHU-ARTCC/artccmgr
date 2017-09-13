class Event < ApplicationRecord
  has_many :positions, class_name: 'Event::Position', dependent: :destroy
  has_many :pilots, class_name: 'Event::Pilot', dependent: :destroy
  has_many :signups, class_name: 'Event::Signup', dependent: :destroy

  validates :name, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :start_time, presence: true, allow_blank: false, time: true
  validates :end_time, presence: true, allow_blank: false, time: true

end
