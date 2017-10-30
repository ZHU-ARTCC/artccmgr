class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :trackable

  extend FriendlyId
  friendly_id :cid

  belongs_to  :group
  belongs_to  :rating

  has_many    :endorsements,    dependent: :destroy
  has_many    :certifications,  through: :endorsements
  has_many    :positions,       through: :certifications

  has_many    :event_positions, class_name: 'Event::Position'
  has_many    :event_flights,   class_name: 'Event::Pilot', dependent: :destroy
  has_many    :event_signups,   class_name: 'Event::Signup', dependent: :destroy

  has_many    :online_sessions, class_name: 'Vatsim::Atc'

  delegate  :atc?,        to: :group
  delegate  :permissions, to: :group
  delegate  :staff?,      to: :group
  delegate  :visiting?,   to: :group

  validates :cid,         presence: true, numericality: :only_integer, allow_blank: false, uniqueness: true
  validates :name_first,  presence: true, allow_blank: false
  validates :name_last,   presence: true, allow_blank: false
  validates :name_last,   presence: true, allow_blank: false
  validates :initials,    length: { maximum: 2 }, allow_blank: true
  validates :email,       presence: true, allow_blank: false
  validates :reg_date,    presence: true, allow_blank: false
  validates :group,       presence: true, allow_blank: false
  validates :rating,      presence: true, allow_blank: false

  # Validates initials must be unique if preference is set
  validates :initials, uniqueness: true, allow_blank: true, if: :require_unique_initials?

  scope :all_controllers,       -> { local_controllers.or(visiting_controllers) }
  scope :local_controllers,     -> { joins(:group).where(groups: { atc: true, visiting: false}) }
  scope :visiting_controllers,  -> { joins(:group).where(groups: { atc: true, visiting: true}) }

  # Find the online activity for user between two dates
  #
  def activity_report(start_date, end_date)
    online_sessions.where('last_seen BETWEEN ? AND ?', start_date, end_date).order(last_seen: :desc)
  end

  # Enforce capitalization on initials
  def initials=(initials)
    super(initials.upcase) unless initials.nil?
  end

  # Determines if this user is a controller at this facility
  def is_controller?
    User.all_controllers.include?(self)
  end

  # Displays first name and last name in one string
  def name_full
    "#{name_first} #{name_last}"
  end

  private

  # Checks settings to determine whether the preference is to require
  # unique operating initials
  def require_unique_initials?
    Settings.unique_operating_initials
  end

end
