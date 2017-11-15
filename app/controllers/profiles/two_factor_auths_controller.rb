class Profiles::TwoFactorAuthsController < ApplicationController
	before_action :authenticate_user!
	# after_action  :verify_authorized

	def create
		if current_user.validate_and_consume_otp!(params[:pin_code])
			current_user.otp_required_for_login = true
			# current_user.otp_secret already saved with show action and now verified
			@codes = current_user.generate_otp_backup_codes!
			current_user.save!
			render 'create'
		else
			@error   = 'Invalid pin code'
			@qr_code = build_qr_code
			setup_u2f_registration
			render 'show'
		end
	end

	def destroy
		current_user.disable_two_factor!
		redirect_to profile_path, status: 302
	end

	def show
		unless current_user.otp_secret
			current_user.otp_secret = User.generate_otp_secret(32)
			current_user.save! # Save the OTP secret for use in #create
		end

		@qr_code = build_qr_code
		setup_u2f_registration
	end

	private

	# Generate the QR code used for setting up TOTP apps
	#
	def build_qr_code
		uri = current_user.otp_provisioning_uri(current_user.cid.to_s, issuer: Settings.artcc_name)
		RQRCode.render_qrcode(uri, :svg, level: :m, unit: 3)
	end

	# Prep communication with a U2F device
	# Actual communication is performed via javascript
	# app/assets/javascripts/profiles/two_factor_auths/u2f.coffee
	#
	def setup_u2f_registration
		@u2f_registration ||= U2fRegistration.new(user: current_user)
		@u2f_registrations = current_user.u2f_registrations

		u2f = U2F::U2F.new(u2f_app_id)

		registration_requests = u2f.registration_requests
		sign_requests         = u2f.authentication_requests(@u2f_registrations.map(&:key_handle))
		session[:challenges]  = registration_requests.map(&:challenge)

		gon.push(u2f: { challenges: session[:challenges], app_id: u2f_app_id,
		                register_requests: registration_requests,
		                sign_requests: sign_requests })
	end

end
