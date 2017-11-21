# frozen_string_literal: true

class PositionPolicy < ApplicationPolicy
  def index?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'position read'
  end

  def show?
    index?
  end

  def create?
    new?
  end

  def new?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'position create'
  end

  def update?
    edit?
  end

  def edit?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'position update'
  end

  def destroy?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'position delete'
  end

  def permitted_attributes
    %i[name frequency callsign identification beacon_codes major primary]
  end
end
