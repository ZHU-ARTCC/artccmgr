class EndorsementPolicy < ApplicationPolicy

	def index?
		@user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
		group.permissions.pluck('name').include? 'endorsement read'
	end

	def show?
		index?
	end

	def create?
		new?
	end

	def new?
		@user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
		group.permissions.pluck('name').include? 'endorsement create'
	end

	def update?
		edit?
	end

	def edit?
		@user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
		group.permissions.pluck('name').include? 'endorsement update'
	end

	def destroy?
		@user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
		group.permissions.pluck('name').include? 'endorsement delete'
	end

	def permitted_attributes
		[ :user, :certification_id, :solo, :instructor ]
	end
end
