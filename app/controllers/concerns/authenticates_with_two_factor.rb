# frozen_string_literal: true

# Controller concern to handle two-factor authentication
#
module AuthenticatesWithTwoFactor
  extend ActiveSupport::Concern

  included do
    # This action comes from DeviseController, but because we call `sign_in`
    # manually, not skipping this action would cause a "You are already signed
    # in." error message to be shown upon successful login.
    # skip_before_action :require_no_authentication, only: [:create]
  end

  # Store the user's ID in the session for later retrieval and render the
  # two factor code prompt
  #
  # The user must have been authenticated with a valid login and password
  # before calling this method!
  #
  # user - User record
  #
  # Returns nil
  def prompt_for_two_factor(user)
    # return locked_user_redirect(user) unless user.can?(:log_in)

    session[:otp_user_id] = user.id
    setup_u2f_authentication(user)
    render 'sessions/two_factor', layout: 'two_factor'
  end

  # def locked_user_redirect(user)
  # 	flash.now[:alert] = 'Invalid Login or password'
  # 	redirect_to root_path
  # end

  def authenticate_with_two_factor
    @user = User.find(session[:otp_user_id])
    # return locked_user_redirect(user) unless user.can?(:log_in)

    if otp_params[:otp_attempt].present? && session[:otp_user_id]
      authenticate_with_two_factor_via_otp(@user)
    elsif otp_params[:user][:device_response].present? && session[:otp_user_id]
      authenticate_with_two_factor_via_u2f(@user)
    elsif @user
      prompt_for_two_factor(@user)
    end
  end

  private

  # Authenticate using the response from TOTP input
  def authenticate_with_two_factor_via_otp(user)
    if valid_otp_attempt?(user)
      # Remove lingering user data from login
      session.delete(:otp_user_id)

      sign_in_and_redirect user, event: :authentication
    else
      flash.now[:alert] = 'Invalid two-factor code.'
      Rails.logger.info(
        "Failed Login: user=#{user.cid} ip=#{request.remote_ip} method=OTP"
      )
      prompt_for_two_factor(user)
    end
  end

  # Authenticate using the response from a U2F (universal 2nd factor) device
  def authenticate_with_two_factor_via_u2f(user)
    if U2fRegistration.authenticate(user,
                                    u2f_app_id,
                                    otp_params[:user][:device_response],
                                    session[:challenge])

      # Remove any lingering user data from login
      session.delete(:otp_user_id)
      session.delete(:challenge)

      sign_in_and_redirect user, event: :authentication
    else
      Rails.logger.info(
        "Failed Login: user=#{user.cid} ip=#{request.remote_ip} method=U2F"
      )
      flash.now[:alert] = 'Authentication via U2F device failed.'
      prompt_for_two_factor(user)
    end
  end

  # Setup in preparation of communication with a U2F device
  # Actual communication is performed using a Javascript API
  def setup_u2f_authentication(user)
    key_handles = user.u2f_registrations.pluck(:key_handle)
    return if key_handles.blank?

    u2f = U2F::U2F.new(u2f_app_id)

    sign_requests = u2f.authentication_requests(key_handles)
    session[:challenge] ||= u2f.challenge
    gon.push(u2f: { challenge: session[:challenge], app_id: u2f_app_id,
                    sign_requests: sign_requests })
  end

  def valid_otp_attempt?(user)
    user.validate_and_consume_otp!(otp_params[:otp_attempt]) ||
      user.invalidate_otp_backup_code!(otp_params[:otp_attempt])
  end

  def otp_params
    params.permit(:utf8, :authenticity_token, :commit, :otp_attempt,
                  user: %i[remember_me device_response])
  end
end
