class Feedback < ApplicationRecord
  paginates_per 50

  validates :cid,           presence: true, allow_blank: false
  validates :name,          presence: true, allow_blank: false
  validates :email,         presence: true, allow_blank: false
  validates :callsign,      presence: true, allow_blank: false
  validates :controller,    presence: true, allow_blank: false
  validates :position,      presence: true, allow_blank: false
  validates :service_level, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :fly_again,     inclusion: { in: [ true, false ] }
  validates :comments,      presence: true, allow_blank: false
  validates :published,     inclusion: { in: [ true, false ] }

  def callsign=(callsign)
    callsign.nil? ? super(callsign) : super(callsign.upcase)
  end
end
