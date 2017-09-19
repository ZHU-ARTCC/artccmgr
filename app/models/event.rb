class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  mount_uploader :image, ImageUploader

  has_many :event_positions, class_name: 'Event::Position', dependent: :destroy, index_errors: true, inverse_of: :event
  has_many :pilots, class_name: 'Event::Pilot', dependent: :destroy
  has_many :signups, class_name: 'Event::Signup', dependent: :destroy

  accepts_nested_attributes_for :event_positions, allow_destroy: true, reject_if: lambda { |a| a[:callsign].blank? }
  validates_associated :event_positions

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

  # Determines when a new friendly id should be generated
  def should_generate_new_friendly_id?
    true
  end

end
