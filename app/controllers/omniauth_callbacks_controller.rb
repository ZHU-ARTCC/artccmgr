class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def vatsim
    @user = User.find_by(cid: request.env['omniauth.auth'].info.id.to_i)

    if @user.present?
      validate @user, request.env['omniauth.auth']

      sign_in_and_redirect @user, event: :authentication
    else
      reason = "Member not found on website"
      set_flash_message(:notice, :failure, kind: 'VATSIM', reason: reason)
      redirect_to root_path
    end
  end

  def failure
    redirect_to root_path
  end

end