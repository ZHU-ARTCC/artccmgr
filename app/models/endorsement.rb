class Endorsement < ApplicationRecord
	belongs_to :user
	belongs_to :certification

	validates :certification, presence: true, allow_blank: false, uniqueness: { scope: :user }
	validates :instructor, presence: true, allow_blank: false
end
