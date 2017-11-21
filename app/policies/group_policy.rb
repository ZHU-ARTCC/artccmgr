# frozen_string_literal: true

class GroupPolicy < ApplicationPolicy
  def index?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'group read'
  end

  def show?
    index?
  end

  def create?
    new?
  end

  def new?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'group create'
  end

  def update?
    edit?
  end

  def edit?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'group update'
  end

  def destroy?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'group delete'
  end

  def permitted_attributes
    [:name, :staff, :atc, :visiting, :min_controlling_hours,
     :two_factor_required, permission_ids: []]
  end
end
