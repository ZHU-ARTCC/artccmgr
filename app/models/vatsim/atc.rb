class Vatsim::Atc < ApplicationRecord
	belongs_to :position
	belongs_to :rating
	belongs_to :user

	validates :callsign,    presence: true, allow_blank: false
	validates :frequency,   presence: true, numericality: { greater_than_or_equal_to: 118, less_than: 137}
	validates :latitude, 	  allow_nil: true, numericality: { greater_than_or_equal_to: -90,  less_than_or_equal_to: 90 }
	validates :longitude,   allow_nil: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
	validates :server,      presence: true, allow_blank: false
	validates :range,       presence: true, numericality: { greater_than_or_equal_to: 0 }
	validates :logon_time,  presence: true

	def callsign=(callsign)
		callsign.nil? ? super(callsign) : super(callsign.upcase)
	end
end
