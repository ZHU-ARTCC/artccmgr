# frozen_string_literal: true

class Position < ApplicationRecord
  extend FriendlyId
  friendly_id :callsign

  belongs_to :certification, optional: true

  validates :frequency,
            presence: true,
            numericality: { greater_than_or_equal_to: 118, less_than: 137 }

  validates :callsign,
            presence: true,
            allow_blank: false,
            uniqueness: { case_sensitive: false }, length: { maximum: 12 }

  validates :name, presence: true, allow_blank: false
  validates :identification, presence: true, allow_blank: false
  validates :beacon_codes, allow_blank: true, length: { maximum: 9 }
  validates :major, inclusion: { in: [true, false] }

  validate :valid_callsign
  validate :valid_certification
  validate :valid_frequency

  # Capitalizes callsigns on assignment
  #
  def callsign=(callsign)
    callsign.nil? ? super(callsign) : super(callsign.upcase)
  end

  # Titleizes radio identification name
  #
  def identification=(id)
    id.nil? ? super(id) : super(id.titleize)
  end

  # Titleizes names
  #
  def name=(name)
    name.nil? ? super(name) : super(name.titleize)
  end

  # Used in forms to present a friendly name "TST_10_CTR (133.95)"
  #
  def to_s
    "#{callsign} (#{frequency})"
  end

  private

  def valid_callsign
    # rubocop:disable Metrics/LineLength
    return if callsign =~ /^[A-Z]{2,4}_([A-Z0-9]{1,3}_)?[(FSS|CTR|APP|DEP|TWR|GND|DEL)]{3}$/
    # rubocop:enable Metrics/LineLength
    errors[:callsign] << 'invalid format'
  end

  def valid_certification
    return if certification.nil?
    type = major? ? 'major' : 'minor'

    return if certification.major? == major?
    errors[:certification] << "of #{type} type exists for this position"
  end

  def valid_frequency
    return if frequency.nil?
    return if format('%.3f', frequency) =~ /^\d{3}.\d{1}(00|20|25|50|70|75){1}$/
    errors[:frequency] << 'invalid'
  end
end
