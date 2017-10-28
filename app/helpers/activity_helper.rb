module ActivityHelper

	# Returns the css class to be used if the user does not meet
	# the minimum activity requirements for the user and duration given
	#
	def activity_minimums_css(user, duration)
		if user.staff?
			mins = Settings.activity_hours_staff.to_i
		elsif user.visiting?
			mins = Settings.activity_hours_visiting.to_i
		else
			mins = Settings.activity_hours.to_i
		end

		duration < mins ? 'bg-danger' : nil
	end

	# Returns paths for viewing previous and next month reports
	#
	def report_controls
		back    = nil
		forward = nil

		start_date = Date.parse((@report_start - 1.month).to_s) # convert Time to Date
		back       = activity_index_path(start_date: start_date)

		if @report_end <= Time.now
			start_date  = Date.parse((@report_start + 1.month).to_s) # convert Time to Date
			forward     = activity_index_path(start_date: start_date)
		end

		{prev: back, next: forward}
	end

end
