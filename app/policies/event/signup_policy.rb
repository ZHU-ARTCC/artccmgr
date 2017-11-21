# frozen_string_literal: true

class Event
  class SignupPolicy < ApplicationPolicy
    def index?
      group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
      group.permissions.pluck('name').include? 'event signup read'
    end

    def show?
      group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
      group.permissions.pluck('name').include? 'event signup read'
    end

    def create?
      new?
    end

    def new?
      group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
      group.permissions.pluck('name').include? 'event signup create'
    end

    def update?
      edit?
    end

    def edit?
      group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
      group.permissions.pluck('name').include? 'event signup update'
    end

    def destroy?
      group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
      group.permissions.pluck('name').include? 'event signup delete'
    end

    def permitted_attributes
      return if (
        @user.group.permissions.pluck('name') &
        ['event signup create', 'event signup update']
      ).blank?

      [:event_id, :user_id, :position,
       requests_attributes: %i[id _destroy position_id]]
    end
  end
end
