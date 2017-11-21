# frozen_string_literal: true

class FeedbackPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      group = @user.nil? ? Group.find_by(name: 'Public') : @user.group

      if group.permissions.pluck('name').include? 'feedback read'
        scope.all.order(created_at: :desc)
      else
        scope.where(published: true).order(created_at: :desc)
      end
    end
  end

  def index?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    (group.permissions.pluck('name') &
    ['feedback read published', 'feedback read']).present?
  end

  def show?
    # scope.where(:id => record.id).exists?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    (group.permissions.pluck('name') &
    ['feedback read published', 'feedback read']).present?
  end

  def create?
    new?
  end

  def new?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'feedback create'
  end

  def update?
    edit?
  end

  def edit?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'feedback update'
  end

  def destroy?
    group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
    group.permissions.pluck('name').include? 'feedback delete'
  end

  def permitted_attributes
    if @user.permissions.pluck('name').include? 'feedback update'
      %i[anonymous cid name email callsign controller position service_level
         comments fly_again published]
    else
      %i[anonymous callsign controller
         position service_level comments fly_again]
    end
  end
end
