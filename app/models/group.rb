# frozen_string_literal: true

class Group < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  BUILT_IN_GROUPS = ['Air Traffic Manager',
                     'Deputy Air Traffic Manager',
                     'Training Administrator',
                     'Facility Engineer',
                     'Events Coordinator',
                     'Webmaster',
                     'Controller',
                     'Guest',
                     'Public'].freeze

  has_many :assignments
  has_many :permissions, through: :assignments
  has_many :users

  before_destroy :ensure_not_builtin
  before_destroy :ensure_no_members

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :min_controlling_hours,
            presence: true,
            numericality: { is_greater_than_or_equal_to: 0 }

  validate :builtin_unchanged

  # Titleize the group name
  #
  def name=(name)
    name.nil? ? super(name) : super(name.titleize)
  end

  private

  # Ensures the built in group names have not changed
  def builtin_unchanged
    return unless name_changed?
    return unless BUILT_IN_GROUPS.include? name_was

    errors[:name] << 'Built in group names cannot be changed'
  end

  # Ensures the group cannot be deleted if members still exist
  def ensure_no_members
    return if users.empty?

    errors[:name] << 'Members still exist for this group'
    throw :abort
  end

  # Ensures the built in groups cannot be deleted
  def ensure_not_builtin
    return unless BUILT_IN_GROUPS.include?(name)

    errors[:name] << 'Built in groups cannot be deleted'
    throw :abort
  end
end
