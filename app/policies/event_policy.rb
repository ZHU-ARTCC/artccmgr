class EventPolicy < ApplicationPolicy

  def index?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'event read'
  end

  def show?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'event read'
  end

  def create?
    new?
  end

  def new?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'event create'
  end

  def update?
    edit?
  end

  def edit?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'event update'
  end

  def destroy?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'event delete'
  end

  def permitted_attributes
    if (@user.group.permissions.pluck('name') & ['event create', 'event update']).present?
      [ :name, :description, :start_time, :end_time, :pilots, :signups, positions: [] ]
    end
  end
end
