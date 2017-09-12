class Group < ApplicationRecord
  has_many :assignments
  has_many :permissions, through: :assignments
  has_many :users

  validates :name, presence: true, uniqueness: true
  validate  :not_both_artcc_and_visiting_controllers

  private

  def not_both_artcc_and_visiting_controllers
    if artcc_controllers && visiting_controllers
      self.errors[:artcc_controllers]    << 'Cannot be both local and visiting controllers'
      self.errors[:visiting_controllers] << 'Cannot be both local and visiting controllers'
    end
  end

end
