class Group < ApplicationRecord
  has_many :assignments
  has_many :permissions, through: :assignments
  has_many :users

  validates :name, presence: true, uniqueness: true
end