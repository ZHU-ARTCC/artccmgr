class PositionPolicy < ApplicationPolicy

  def index?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'position read'
  end

  def show?
    index?
  end

  def create?
    new?
  end

  def new?
    @user.permissions.pluck('name').include? 'position create'
  end

  def update?
    edit?
  end

  def edit?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'position update'
  end

  def destroy?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'position delete'
  end

  def permitted_attributes
    [ :name, :frequency, :callsign, :identification, :beacon_codes, :major ]
  end
end
