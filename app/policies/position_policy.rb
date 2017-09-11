class PositionPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group

      if group.permissions.pluck('name').include? 'position read'
        scope.all.order(created_at: :desc)
      else
        scope.where(published: true).order(created_at: :desc)
      end
    end
  end

  def index?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'position read'
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    new?
  end

  def new?
    @user.permissions.pluck('name').include? 'position create'
  end

  def update?
    false
  end

  def edit?
    false
  end

  def destroy?
    false
  end

end
