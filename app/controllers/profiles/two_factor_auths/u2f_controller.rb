# frozen_string_literal: true

class Profiles::TwoFactorAuths::U2fController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def create
    @u2f_registration = U2fRegistration.register(current_user,
                                                 u2f_app_id,
                                                 u2f_registration_params,
                                                 session[:challenges])
    authorize @u2f_registration

    if @u2f_registration.persisted?
      session.delete(:challenges)
      redirect_to profile_two_factor_auth_path,
                  notice: 'Your U2F device was registered!'
    else
      redirect_to profile_two_factor_auth_path
    end
  end

  def destroy
    @u2f_registration = U2fRegistration.find_by(user: current_user,
                                                id:   params[:id])
    authorize @u2f_registration

    if @u2f_registration.destroy
      redirect_to profile_two_factor_auth_path,
                  notice: 'Your U2F device was removed!'
    else
      redirect_to profile_two_factor_auth_path,
                  alert: 'Unable to remove your U2F device!'
    end
  end

  private

  def u2f_registration_params
    params.require(:u2f_registration).permit(:device_response, :name)
  end
end
