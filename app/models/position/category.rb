# frozen_string_literal: true

class Position::Category < ApplicationRecord
  has_many :positions

  validates :name,  presence: true
  validates :short, presence: true, uniqueness: true, length: { maximum: 7 }

  default_scope { order(:name) }
end
