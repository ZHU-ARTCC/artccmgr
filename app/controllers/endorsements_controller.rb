class EndorsementsController < ApplicationController
	before_action :authenticate_user!
	after_action :verify_authorized

	def create
		authorize Endorsement, :create?
		instructor = "#{current_user.name_first} #{current_user.name_last}"

		@controller  = User.friendly.find(params[:user_id])
		@endorsement = Endorsement.new(user: @controller, instructor: instructor)

		if @endorsement.update_attributes(permitted_attributes(@endorsement))
			redirect_to user_path(@controller), success: 'Endorsement has been created'
		else
			flash.now[:alert] = 'Unable to create endorsement'
			render :new
		end
	end

	def destroy
		authorize Endorsement, :destroy?
		@controller  = User.friendly.find(params[:user_id])
		@endorsement = policy_scope(Endorsement).find(params[:id])

		if @endorsement.destroy
			redirect_to user_path(@controller), success: 'Endorsement has been revoked'
		else
			redirect_to edit_user_endorsement_path(@controller, @endorsement), alert: 'Unable to delete endorsement'
		end
	end

	def edit
		@controller  = User.friendly.find(params[:user_id])
		@endorsement = policy_scope(Endorsement).find(params[:id])
		authorize @endorsement
	end

	def new
		@controller  = User.friendly.find(params[:user_id])
		@endorsement = Endorsement.new(user: @controller)
		authorize @endorsement
	end

	def update
		authorize Endorsement, :update?
		@controller  = User.friendly.find(params[:user_id])
		@endorsement = policy_scope(Endorsement).find(params[:id])

		if @endorsement.update_attributes(permitted_attributes(@endorsement))
			flash[:success] = 'Endorsement has been updated'
			redirect_to user_path(@controller)
		else
			flash.now[:alert] = 'Unable to update endorsement'
			render :edit
		end
	end

end
