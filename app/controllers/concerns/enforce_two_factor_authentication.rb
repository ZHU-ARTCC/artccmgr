# Enforce Two Factor Authentication
#
# Controller concern to enforce two-factor authentication requirements
#
# Upon inclusion, adds `checks_for_two_factor_requirement` as a before_action.
# Based on work of the Gitlab team
#
module EnforceTwoFactorAuthentication
	extend ActiveSupport::Concern

	included do
		before_action :check_two_factor_requirement
	end

	def check_two_factor_requirement
		if current_user && current_user.two_factor_required? && !current_user.two_factor_enabled?
			msg = 'You must configure two-factor authentication to continue'
			redirect_to profile_two_factor_auth_path, alert: msg
		end
	end
end
