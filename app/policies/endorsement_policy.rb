# frozen_string_literal: true

class EndorsementPolicy < ApplicationPolicy
  def index?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'endorsement read'
  end

  def show?
    index?
  end

  def create?
    new?
  end

  def new?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'endorsement create'
  end

  def update?
    edit?
  end

  def edit?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'endorsement update'
  end

  def destroy?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'endorsement delete'
  end

  def permitted_attributes
    %i[user certification_id solo instructor]
  end
end
