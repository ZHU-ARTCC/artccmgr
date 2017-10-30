class Rating < ApplicationRecord
	has_many :users

	validates :number,      presence: true, numericality: { greater_than_or_equal_to: 0 }
	validates :short_name,  presence: true, allow_blank: false
	validates :long_name,   presence: true, allow_blank: false

	# Integer value of Rating
	#
	def to_i
		number.to_i
	end

	# Full name of rating
	#
	def to_s
		long_name.to_s
	end

end
