class FeedbackPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.permissons.pluck('name').include? 'feedback read'
        scope.all.order(created_at: :desc)
      else
        scope.where(published: true).order(created_at: :desc)
      end
    end
  end

  def index?
    @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
    group.permissions.pluck('name').include? 'feedback read published'
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    new?
  end

  def new?
    @user.permissions.pluck('name').include? 'feedback create'
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

# class FeedbackPolicy
#   attr_reader :user, :record
#
#   def initialize(user, record)
#     @user = user
#     @record = record
#   end
#
#   def index?
#     @user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
#     group.permissions.pluck('name').include? 'feedback read'
#   end
#
#   def show?
#     scope.where(:id => record.id).exists?
#   end
#
#   def create?
#     new?
#   end
#
#   def new?
#     @user.permissions.pluck('name').include? 'feedback create'
#   end
#
#   def update?
#     false
#   end
#
#   def edit?
#     false
#   end
#
#   def destroy?
#     false
#   end
#
#   def scope
#     Pundit.policy_scope!(user, record.class)
#   end
#
#   # class Scope
#   #   attr_reader :user, :scope
#   #
#   #   def initialize(user, scope)
#   #     @user = user
#   #     @scope = scope
#   #   end
#   #
#   #   def resolve
#   #     if user.admin?
#   #       scope.all
#   #     else
#   #       scope.where(published: true)
#   #     end
#   #   end
#   # end
# end
