class Assignment < ApplicationRecord
  belongs_to :group
  belongs_to :permission

  validates :group,      presence: true, allow_blank: false
  validates :permission, presence: true, allow_blank: false
end
