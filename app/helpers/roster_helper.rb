module RosterHelper

	# Determines the certification status for a given User and Certification
	# and returns the appropriate CSS background class name for the view.
	#
	# Returns CSS background class as String
	#
	def cert_status_css(user, certification)
		endorsement = user.endorsements.find_by(certification: certification)

		if endorsement
			endorsement.solo? ? 'bg-warning' : 'bg-success'
		else
			nil
		end
	end # def cert_status_css

	# Creates the array of operating initials options dependent on the
	# preference to allow duplicate OIs or not
	def initials_options
		if Settings.unique_operating_initials
			disabled = User.all.pluck(:initials).reject{|i| i.nil?}
		else
			disabled = false
		end

		options_for_select(('AA'..'ZZ').to_a, selected: @user.initials, disabled: disabled)
	end # def initials_options

end
