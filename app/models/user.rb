class User < ApplicationRecord
  devise :two_factor_authenticatable,
         :two_factor_backupable,
         otp_backup_code_length:      10,
         otp_number_of_backup_codes:  5,
         otp_secret_encryption_key:   Rails.application.secrets.secret_key_base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :trackable

  # Have ActiveRecord track this attribute
  attribute :otp_secret

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

  has_many    :u2f_registrations, dependent: :destroy

  delegate  :atc?,                  to: :group
  delegate  :min_controlling_hours, to: :group
  delegate  :permissions,           to: :group
  delegate  :staff?,                to: :group
  delegate  :visiting?,             to: :group

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

  # Disables all two-factor authentication
  def disable_two_factor!
    transaction do
      update_attributes(
          otp_required_for_login:     false,
          encrypted_otp_secret:       nil,
          encrypted_otp_secret_iv:    nil,
          encrypted_otp_secret_salt:  nil,
      )
      self.u2f_registrations.destroy_all
    end
  end

  # Devise two factor auth gem replaces database authenticatable methods
  # in Devise. As a result, it expects to be able to find an encrypted_password.
  # Since we use VATSIM SSO for authentication, we just need to return nil.
  #
  def encrypted_password
    nil
  end

  # Enforce capitalization on initials
  def initials=(initials)
    super(initials.upcase) unless initials.nil?
  end

  # Determines if this user is a controller at this facility
  def is_controller?
    User.all_controllers.include?(self)
  end

  # Determines if this user is a member of this ARTCC
  def is_local?
    User.local_controllers.include?(self)
  end

  # Titleize the first name
  def name_first=(name)
    name.nil? ? super(name) : super(name.titleize)
  end

  # Titleize the last name
  def name_last=(name)
    name.nil? ? super(name) : super(name.titleize)
  end

  # Displays first name and last name in one string
  def name_full
    "#{name_first} #{name_last}"
  end

  # Determines whether the user has enabled 2FA
  def two_factor_enabled?
    two_factor_otp_enabled? || two_factor_u2f_enabled?
  end

  # Determines whether the user has TOTP enabled for 2FA
  def two_factor_otp_enabled?
    otp_required_for_login?
  end

  # Determines whether the user has a U2F device configured
  def two_factor_u2f_enabled?
    u2f_registrations.exists?
  end

  private

  # Checks settings to determine whether the preference is to require
  # unique operating initials
  def require_unique_initials?
    Settings.unique_operating_initials
  end

end
