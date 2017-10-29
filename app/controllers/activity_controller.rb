class ActivityController < ApplicationController
	before_action :authenticate_user!
	after_action :verify_authorized

	def index
		raise Pundit::NotAuthorizedError, 'Not allowed to view this page' unless current_user.staff?

		@controllers = User.local_controllers.order(:name_last, :name_first)
		@visiting_controllers = User.visiting_controllers.order(:name_last, :name_first)

		if params['start_date']
			@report_start = Time.parse(params['start_date']).beginning_of_month.at_beginning_of_day
		else
			@report_start = Time.now.beginning_of_month.at_beginning_of_day
		end

		@report_end = @report_start.end_of_month.at_end_of_day

		authorize @controllers
		authorize @visiting_controllers
	end

end
