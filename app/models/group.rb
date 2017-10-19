class Group < ApplicationRecord
  has_many :assignments
  has_many :permissions, through: :assignments
  has_many :users

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # Titleize the group name
  #
  def name=(name)
    name.nil? ? super(name) : super(name.titleize)
  end

end
