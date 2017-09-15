class Event < ApplicationRecord
  has_many :positions, class_name: 'Event::Position', dependent: :destroy
  has_many :pilots, class_name: 'Event::Pilot', dependent: :destroy
  has_many :signups, class_name: 'Event::Signup', dependent: :destroy

  validates :name, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :start_time, presence: true, allow_blank: false, time: true
  validates :end_time, presence: true, allow_blank: false, time: true

  validate :ends_after_start

  private

  # Validates the end time is after the start time
  def ends_after_start
    unless end_time.nil? || start_time.nil?
      errors[:end_time] << 'cannot be before start time' if end_time < start_time
    end
  end

end
