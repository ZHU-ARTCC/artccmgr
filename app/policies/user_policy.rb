class UserPolicy < ApplicationPolicy

  def initialize(user, obj)
    @user = user
    @obj  = obj
  end

  def index?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    group.permissions.pluck('name').include? 'user read'
  end

  def show?
    index? || @user == @obj
  end

  def create?
    new?
  end

  def new?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    group.permissions.pluck('name').include? 'user create'
  end

  def update?
    edit?
  end

  def edit?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    group.permissions.pluck('name').include?('user update')
  end

  def destroy?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    group.permissions.pluck('name').include? 'user delete'
  end

  def permitted_attributes
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    if (group.permissions.pluck('name') & ['user create', 'user update']).present?
      [ :cid, :name_first, :name_last, :email, :reg_date, :group_id, :initials, :rating_id ]
    # elsif @user == @obj
    #   []
    end
  end
end
