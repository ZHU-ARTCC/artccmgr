# frozen_string_literal: true

class Airport < ApplicationRecord
  extend FriendlyId
  friendly_id :icao

  has_one :weather, dependent: :destroy
  has_many :charts, class_name: 'Airport::Chart', dependent: :destroy

  validates :icao,
            presence: true,
            allow_blank: false,
            length: { maximum: 4 },
            uniqueness: { case_sensitive: false }

  validates :elevation, allow_nil: true, numericality: {}

  validates :latitude,
            allow_nil: true,
            numericality: {
              greater_than_or_equal_to: -90,
              less_than_or_equal_to: 90
            }

  validates :longitude,
            allow_nil: true,
            numericality: {
              greater_than_or_equal_to: -180,
              less_than_or_equal_to: 180
            }

  validates :name, presence: true, allow_blank: false

  after_create :queue_update

  # Ensure ICAO identifiers are uppercase
  #
  def icao=(ident)
    ident.nil? ? super(ident) : super(ident.upcase)
  end

  # Ensure name is titleized
  #
  def name=(name)
    name.nil? ? super(name) : super(name.titleize)
  end

  private

  # Queue the AirportUpdate job to poll data
  #
  def queue_update
    AirportUpdateJob.perform_later(self)
  end
end
