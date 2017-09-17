class Event < ApplicationRecord
  has_many :positions, class_name: 'Event::Position', dependent: :destroy
  has_many :pilots, class_name: 'Event::Pilot', dependent: :destroy
  has_many :signups, class_name: 'Event::Signup', dependent: :destroy

  validates :name, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :start_time, presence: true, allow_blank: false, time: true
  validates :end_time, presence: true, allow_blank: false, time: true

  validate :start_after_now
  validate :ends_after_start

  private
  
  # Validates the start time is not in the past
  def start_after_now
    unless start_time.nil? || end_time.nil?
      errors[:start_time] << "can't be in the past" if start_time < Time.now
    end
  end

  # Validates the end time is after the start time
  def ends_after_start
    unless end_time.nil? || start_time.nil?
      errors[:end_time] << "can't be before start time" if end_time < start_time
    end
  end

end
