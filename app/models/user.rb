class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :trackable

  belongs_to  :group
  has_many    :event_positions, class_name: 'Event::Position'
  has_many    :event_flights, class_name: 'Event::Pilot'

  delegate    :permissions, to: :group

  validates :cid,         presence: true, numericality: :only_integer, allow_blank: false
  validates :name_first,  presence: true, allow_blank: false
  validates :name_last,   presence: true, allow_blank: false
  validates :name_last,   presence: true, allow_blank: false
  validates :initials,    length: { maximum: 2 }, allow_blank: true
  validates :email,       presence: true, allow_blank: false
  validates :rating,      presence: true, length: { maximum: 3 }, allow_blank: false
  validates :reg_date,    presence: true, allow_blank: false
  validates :group,       presence: true, allow_blank: false

  scope :all_controllers, -> { artcc_controllers.or(visiting_controllers) }
  scope :artcc_controllers, -> { joins(:group).where(groups: { artcc_controllers: true}) }
  scope :visiting_controllers, -> { joins(:group).where(groups: { visiting_controllers: true}) }

  def name_full
    "#{name_first} #{name_last}"
  end

end
