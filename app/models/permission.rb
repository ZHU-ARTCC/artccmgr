# frozen_string_literal: true

class Permission < ApplicationRecord
  has_many :assignments
  has_many :groups, through: :assignments

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end
end
