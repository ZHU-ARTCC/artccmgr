# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include EnforceTwoFactorAuthentication
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :store_current_location, unless: :devise_controller?
  before_action :online,  unless: :devise_controller?
  before_action :metar,   unless: :devise_controller?

  skip_before_action :check_two_factor_requirement, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end

  private

  # Used to identify the AppID for U2F
  def u2f_app_id
    request.base_url
  end

  # Obtain the Controllers Online
  #
  def online
    @online_atc = Vatsim::Atc.where(
      last_seen: (Time.now.utc - 3.minutes)..Time.now.utc
    )
  end

  # Obtain and display the latest METAR information received
  #
  def metar
    @metar = Weather.joins(:airport).where(airports: { show_metar: true })\
                    .order('airports.icao asc')
  end

  # override the devise helper to store the current location so we can
  # redirect to it after logging in or out. This override makes signing in
  # and signing up work automatically.
  def store_current_location
    store_location_for(:user, request.url)
  end

  # Rescue from Pundit::NotAuthorized and return to referrer or root_path
  #
  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to root_path

    # continue to raise Pundit errors if under test
    raise Pundit::NotAuthorizedError if Rails.env.test?
  end
end
