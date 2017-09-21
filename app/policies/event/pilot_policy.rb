class Event

  class PilotPolicy < ApplicationPolicy

    def index?
      @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
      group.permissions.pluck('name').include? 'event pilot signup read'
    end

    def show?
      @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
      group.permissions.pluck('name').include? 'event pilot signup read'
    end

    def create?
      new?
    end

    def new?
      @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
      group.permissions.pluck('name').include? 'event pilot signup create'
    end

    def update?
      edit?
    end

    def edit?
      @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
      group.permissions.pluck('name').include? 'event pilot signup update'
    end

    # Allows for Pilots to delete their own registrations
    def destroy?
      @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
      set_permission = group.permissions.pluck('name').include? 'event pilot signup delete'
      if @record
        set_permission || @user == @record.user
      else
        set_permission
      end
    end

    def permitted_attributes
      if (@user.group.permissions.pluck('name') & ['event pilot signup create', 'event pilot signup update']).present?
        [ :event_id, :user_id, :callsign ]
      end
    end

  end

end
