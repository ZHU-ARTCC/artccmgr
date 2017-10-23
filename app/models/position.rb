class Position < ApplicationRecord
  extend FriendlyId
  friendly_id :callsign

  belongs_to :certification, optional: true

  validates :name, presence: true, allow_blank: false
  validates :frequency, presence: true, numericality: { greater_than_or_equal_to: 118, less_than: 137}
  validates :callsign, presence: true, allow_blank: false, uniqueness: {case_sensitive: false}, length: {maximum: 11}
  validates :identification, presence: true, allow_blank: false
  validates :beacon_codes, allow_blank: true, length: {maximum: 9}
  validates :major, inclusion: { in: [ true, false ] }

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
    unless callsign =~ /^[A-Z]{3}_([A-Z0-9]{1,3}_)?[(FSS|CTR|APP|DEP|TWR|GND|DEL)]{3}$/
      self.errors[:callsign] << 'invalid format'
    end
  end

  def valid_certification
    unless certification.nil?
      type = major? ? 'major' : 'minor'
      self.errors[:certification] << "of #{type} type exists for this position" unless certification.major? == major?
    end
  end

  def valid_frequency
    unless frequency.nil?
      unless '%.3f' % frequency =~ /^\d{3}.\d{1}(00|20|25|50|70|75){1}$/
        self.errors[:frequency] << 'invalid'
      end
    end
  end

end
