class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :trackable

  belongs_to  :group
  has_many    :events, through: :event_positions
  has_many    :event_positions, class_name: 'Event::Controller'

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

  scope :all_controllers, -> do
    artcc_controllers.or(visiting_controllers)
  end

  scope :artcc_controllers, -> do
    joins(:group).where(groups: { artcc_controllers: true})
  end

  scope :visiting_controllers, -> do
    joins(:group).where(groups: { visiting_controllers: true})
  end

  def name_full
    "#{name_first} #{name_last}"
  end

end
