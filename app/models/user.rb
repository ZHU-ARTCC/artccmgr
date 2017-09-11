class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :trackable

  belongs_to  :group
  delegate    :permissions, to: :group

  validates :cid,         presence: true, numericality: :only_integer, allow_blank: false
  validates :name_first,  presence: true, allow_blank: false
  validates :name_last,   presence: true, allow_blank: false
  validates :name_last,   presence: true, allow_blank: false
  validates :email,       presence: true, allow_blank: false
  validates :rating,      presence: true, length: { maximum: 3 }, allow_blank: false
  validates :reg_date,    presence: true, allow_blank: false
  validates :group,       presence: true, allow_blank: false

  def name
    "#{name_first} #{name_last}"
  end

end
