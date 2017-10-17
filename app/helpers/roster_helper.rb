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

end
