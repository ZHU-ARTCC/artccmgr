class CertificationsController < ApplicationController

	before_action :authenticate_user!
	after_action :verify_authorized

	def index
		@certifications = Certification.all
		authorize @certifications
	end

	def create
		authorize Certification, :create?
		@certification = Certification.new

		if @certification.update_attributes(permitted_attributes(@certification))
			redirect_to certifications_path, success: 'Certification has been saved'
		else
			flash.now[:alert] = 'Unable to create certification'
			render :new
		end
	end

	def destroy
		authorize Certification, :destroy?
		@certification = policy_scope(Certification).find(params[:id])

		if @certification.destroy
			redirect_to certifications_path, success: 'Certification has been deleted'
		else
			redirect_to certifications_path(@certification), alert: 'Unable to delete position'
		end
	end

	def edit
		@certification = policy_scope(Certification).find(params[:id])
		authorize @certification
	end

	def new
		@certification = Certification.new
		authorize @certification
	end

	def show
		@certification = policy_scope(Certification).find(params[:id])
		authorize @certification
	end

	def update
		authorize Certification, :update?
		@certification = policy_scope(Certification).find(params[:id])

		if @certification.update_attributes(permitted_attributes(@certification))
			flash[:success] = "#{@certification.name} certification has been updated"
			redirect_to certifications_path
		else
			flash.now[:alert] = 'Unable to update certification'
			render :edit
		end
	end

end
