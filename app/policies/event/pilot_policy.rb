# frozen_string_literal: true

class Event
  class PilotPolicy < ApplicationPolicy
    def index?
      group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
      group.permissions.pluck('name').include? 'event pilot signup read'
    end

    def show?
      group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
      group.permissions.pluck('name').include? 'event pilot signup read'
    end

    def create?
      new?
    end

    def new?
      group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
      group.permissions.pluck('name').include? 'event pilot signup create'
    end

    def update?
      edit?
    end

    def edit?
      group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
      group.permissions.pluck('name').include? 'event pilot signup update'
    end

    # Allows for Pilots to delete their own registrations
    def destroy?
      group = @user.nil? ? Group.find_by(name: 'Public') : @user.group
      set_permission = group.permissions.pluck('name').include?(
        'event pilot signup delete'
      )
      if @record
        set_permission || @user == @record.user
      else
        set_permission
      end
    end

    def permitted_attributes
      return if (
        @user.group.permissions.pluck('name') &
        ['event pilot signup create', 'event pilot signup update']
      ).blank?

      %i[event_id user_id callsign]
    end
  end
end
