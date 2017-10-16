class Weather < ApplicationRecord
	belongs_to :airport

	delegate :icao, to: :airport

	validates :rules,     presence: true, allow_blank: false
	validates :wind,      presence: true, allow_blank: false
	validates :altimeter, presence: true, allow_blank: false
	validates :metar,     presence: true, allow_blank: false
end
