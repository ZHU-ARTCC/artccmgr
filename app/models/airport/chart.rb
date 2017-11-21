# frozen_string_literal: true

class Airport::Chart < ApplicationRecord
  belongs_to :airport

  validates :category, presence: true, allow_blank: false
  validates :name,     presence: true, allow_blank: false
  validates :url,      presence: true, allow_blank: false
end
