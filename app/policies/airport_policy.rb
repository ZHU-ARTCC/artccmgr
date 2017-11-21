# frozen_string_literal: true

class AirportPolicy < ApplicationPolicy
  def index?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'airport read'
  end

  def show?
    index?
  end

  def create?
    new?
  end

  def new?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'airport create'
  end

  def update?
    edit?
  end

  def edit?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'airport update'
  end

  def destroy?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'airport delete'
  end

  def permitted_attributes
    %i[icao name show_metar]
  end
end
