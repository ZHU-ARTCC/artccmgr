# frozen_string_literal: true

class Feedback < ApplicationRecord
  paginates_per 10

  validates :anonymous,     inclusion: { in: [true, false] }

  validates :cid, presence: true, allow_blank: false, unless: :anonymous?
  validates :name, presence: true, allow_blank: false, unless: :anonymous?
  validates :email, presence: true, allow_blank: false, unless: :anonymous?
  validates :callsign, presence: true, allow_blank: false, unless: :anonymous?
  validates :controller, presence: true, allow_blank: false
  validates :position, presence: true, allow_blank: false
  validates :fly_again, inclusion: { in: [true, false] }
  validates :comments, presence: true, allow_blank: false
  validates :published, inclusion: { in: [true, false] }

  validates :service_level,
            presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 5 }

  # Forces the callsign to upper case
  #
  def callsign=(callsign)
    callsign.nil? ? super(callsign) : super(callsign.upcase)
  end
end
