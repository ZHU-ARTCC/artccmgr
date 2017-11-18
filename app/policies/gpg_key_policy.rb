class GpgKeyPolicy < ApplicationPolicy

  def initialize(user, obj)
    @user = user
    @reg  = obj
  end

  def index?
    @user == @reg.user
  end

  def show?
    @user == @reg.user
  end

  def create?
    new?
  end

  def new?
    @user == @reg.user
  end

  def update?
    edit?
  end

  def edit?
    @user == @reg.user
  end

  def destroy?
    @user == @reg.user #|| @user.group.permissions.pluck('name').include?('user update')
  end

  def permitted_attributes
  	[:key]
  end
end
