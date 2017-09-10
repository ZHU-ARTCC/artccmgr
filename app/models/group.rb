class Group < ApplicationRecord
  has_many :assignments
  has_many :permissions, through: :assignments
end
