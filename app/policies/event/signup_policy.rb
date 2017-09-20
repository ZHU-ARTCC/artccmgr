class Event

  class SignupPolicy < ApplicationPolicy

    def index?
      @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
      group.permissions.pluck('name').include? 'event signup read'
    end

    def show?
      @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
      group.permissions.pluck('name').include? 'event signup read'
    end

    def create?
      new?
    end

    def new?
      @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
      group.permissions.pluck('name').include? 'event signup create'
    end

    def update?
      edit?
    end

    def edit?
      @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
      group.permissions.pluck('name').include? 'event signup update'
    end

    def destroy?
      @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
      group.permissions.pluck('name').include? 'event signup delete'
    end

    def permitted_attributes
      if (@user.group.permissions.pluck('name') & ['event signup create', 'event signup update']).present?
        [ :event_id, :user_id, :position, requests_attributes: [ :id, :_destroy, :position_id ] ]
      end
    end

  end

end
