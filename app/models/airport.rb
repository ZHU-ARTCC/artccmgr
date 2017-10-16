class Airport < ApplicationRecord
	has_one :weather, dependent: :destroy

	validates :icao,
	          presence: true,
	          allow_blank: false,
	          length: { maximum: 4 },
						uniqueness: { case_sensitive: false }

	validates :name, presence: true, allow_blank: false

end
