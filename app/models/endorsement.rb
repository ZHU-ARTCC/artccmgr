class Endorsement < ApplicationRecord
	belongs_to :user
	belongs_to :certification

	validates :certification, uniqueness: { scope: :user }
	validates :instructor, presence: true, allow_blank: false
end
