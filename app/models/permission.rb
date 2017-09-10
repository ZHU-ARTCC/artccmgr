class Permission < ApplicationRecord
  has_many :assignments
  has_many :groups, through: :assignments

  validates :name, presence: true, uniqueness: true
end
