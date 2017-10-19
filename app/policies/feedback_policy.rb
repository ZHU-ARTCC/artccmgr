class FeedbackPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group

      if group.permissions.pluck('name').include? 'feedback read'
        scope.all.order(created_at: :desc)
      else
        scope.where(published: true).order(created_at: :desc)
      end
    end
  end

  def index?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    (group.permissions.pluck('name') & ['feedback read published', 'feedback read']).present?
  end

  def show?
    # scope.where(:id => record.id).exists?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    (group.permissions.pluck('name') & ['feedback read published', 'feedback read']).present?
  end

  def create?
    new?
  end

  def new?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    group.permissions.pluck('name').include? 'feedback create'
  end

  def update?
    edit?
  end

  def edit?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    group.permissions.pluck('name').include? 'feedback update'
  end

  def destroy?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    group.permissions.pluck('name').include? 'feedback delete'
  end

  def permitted_attributes
    if @user.permissions.pluck('name').include? 'feedback update'
      [ :anonymous, :cid, :name, :email, :callsign, :controller, :position, :service_level,
        :comments, :fly_again, :published
      ]
    else
      [ :anonymous, :callsign, :controller, :position, :service_level, :comments, :fly_again ]
    end
  end
end
