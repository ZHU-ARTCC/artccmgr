class UserPolicy < ApplicationPolicy

  def index?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'user read'
  end

  def show?
    index?
  end

  def create?
    new?
  end

  def new?
    @user.permissions.pluck('name').include? 'user create'
  end

  def update?
    edit?
  end

  def edit?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'user update'
  end

  def destroy?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'user delete'
  end

  def permitted_attributes
    []
  end
end
