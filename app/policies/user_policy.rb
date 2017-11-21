# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def initialize(user, obj)
    @user = user
    @obj  = obj
  end

  def index?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'user read'
  end

  def show?
    index? || @user == @obj
  end

  def create?
    new?
  end

  def new?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'user create'
  end

  def update?
    edit?
  end

  def edit?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include?('user update')
  end

  def destroy?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'user delete'
  end

  def permitted_attributes
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group

    return if (
      group.permissions.pluck('name') & ['user create', 'user update']
    ).blank?

    %i[cid name_first name_last email reg_date group_id initials rating_id]
  end
end
