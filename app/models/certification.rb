# frozen_string_literal: true

class Certification < ApplicationRecord
  has_many :endorsements, dependent: :destroy
  has_many :positions
  has_many :users, through: :endorsements

  validates :name,
            presence: true,
            allow_blank: false,
            uniqueness: {
              case_sensitive: false,
              scope: :major
            }

  validates :short_name, presence: true, allow_blank: false

  validate :same_kind

  # Titleize the name
  #
  def name=(name)
    name.nil? ? super(name) : super(name.titleize)
  end

  # Ensure the short name is capitalized
  #
  def short_name=(name)
    name.nil? ? super(name) : super(name.upcase)
  end

  private

  # Validates that a certification contains only major or minor
  # positions but not a combination of both
  def same_kind
    return if positions.blank?

    # rubocop:disable Style/GuardClause
    if positions.collect(&:major).uniq != [major?]
      errors[:positions] << 'must match major certification status'
    end
    # rubocop:enable Style/GuardClause
  end
end
