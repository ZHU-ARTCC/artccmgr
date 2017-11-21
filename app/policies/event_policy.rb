# frozen_string_literal: true

class EventPolicy < ApplicationPolicy
  def index?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'event read'
  end

  def show?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'event read'
  end

  def create?
    new?
  end

  def new?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'event create'
  end

  def update?
    edit?
  end

  def edit?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'event update'
  end

  def destroy?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'event delete'
  end

  def permitted_attributes
    return if (
      @user.group.permissions.pluck('name') &
      ['event create', 'event update']
    ).blank?

    [:name, :description, :start_time, :end_time, :image, :remove_image,
     :pilots, :signups,
     event_positions_attributes: %i[id callsign user _destroy]]
  end
end
