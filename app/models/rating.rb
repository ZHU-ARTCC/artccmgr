# frozen_string_literal: true

class Rating < ApplicationRecord
  has_many :users

  validates :number,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :short_name,  presence: true, allow_blank: false
  validates :long_name,   presence: true, allow_blank: false

  delegate :to_i, to: :number

  # Full name of rating
  #
  def to_s
    "#{long_name} (#{short_name})"
  end
end
