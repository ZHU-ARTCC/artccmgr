class Position < ApplicationRecord

  validates :name, presence: true, allow_blank: false
  validates :frequency, presence: true, numericality: { greater_than_or_equal_to: 118, less_than: 137}
  validates :callsign, presence: true, allow_blank: false, uniqueness: {case_sensitive: false}, length: {maximum: 11}
  validates :identification, presence: true, allow_blank: false
  validates :beacon_codes, allow_blank: true, length: {maximum: 9}
  validates :major, inclusion: { in: [ true, false ] }

  def callsign=(callsign)
    callsign.nil? ? super(callsign) : super(callsign.upcase)
  end

end
