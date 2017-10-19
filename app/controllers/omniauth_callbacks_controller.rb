class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def failure
    set_flash_message(:notice, :failure, kind: 'VATSIM', reason: 'OAuth failure.')
    redirect_to root_path
  end

  def vatsim
    @user = User.find_by(cid: request.env['omniauth.auth'].info.id.to_i)

    if @user.present?
      #@user.validate_vatsim_data(request.env['omniauth.auth'])
      sign_in_and_redirect @user, event: :authentication
    else
      #reason = "Member not found on website"
      #set_flash_message(:notice, :failure, kind: 'VATSIM', reason: reason)

      sso_info = request.env['omniauth.auth'].info

      @user = User.create(
               cid:         sso_info.id.to_i,
               name_first:  sso_info.name_first,
               name_last:   sso_info.name_last,
               email:       sso_info.email,
               rating:      Rating.find_by(number: sso_info.rating.id.to_i),
               reg_date:    sso_info.reg_date,
               group:       Group.find_by(name: 'Guest')
      )

      sign_in_and_redirect @user, event: :authentication
    end
  end

end
