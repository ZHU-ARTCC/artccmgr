class Certification < ApplicationRecord

  has_many :positions
  has_and_belongs_to_many :users, join_table: 'user_certifications'

  validates :name, presence: true, allow_blank: false, uniqueness: {case_sensitive: false}
  validates :positions, length: { minimum: 1, message: 'most contain at least one' }
  validate :same_kind

  private

  # Validates that a certification contains only major or minor
  # positions but not a combination of both
  def same_kind
    if positions.collect(&:major).uniq.size > 1
      errors[:positions] << 'cannot contain both major and minor'
    end
  end

end
