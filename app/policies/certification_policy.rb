class CertificationPolicy < ApplicationPolicy

	def index?
		@user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
		group.permissions.pluck('name').include? 'certification read'
	end

	def show?
		index?
	end

	def create?
		new?
	end

	def new?
		@user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
		group.permissions.pluck('name').include? 'certification create'
	end

	def update?
		edit?
	end

	def edit?
		@user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
		group.permissions.pluck('name').include? 'certification update'
	end

	def destroy?
		@user.nil? ? group = Group.find_by(name: 'public') : group = @user.group
		group.permissions.pluck('name').include? 'certification delete'
	end

	def permitted_attributes
		[ :name, :short_name, :show_on_roster, :major, position_ids: [] ]
	end
end
