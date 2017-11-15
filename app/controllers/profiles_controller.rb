class ProfilesController < ApplicationController
	before_action :authenticate_user!
	after_action  :verify_authorized

	def show
		@user = current_user
		authorize @user
	end

end
