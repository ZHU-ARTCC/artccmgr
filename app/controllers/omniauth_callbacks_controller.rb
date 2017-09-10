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

      @user = User.create(
               cid:         request.env['omniauth.auth'].info.id.to_i,
               name_first:  request.env['omniauth.auth'].info.name_first,
               name_last:   request.env['omniauth.auth'].info.name_last,
               email:       request.env['omniauth.auth'].info.email,
               rating:      request.env['omniauth.auth'].info.rating['short'],
               reg_date:    request.env['omniauth.auth'].info.reg_date,
               group:       Group.find_by(name: 'guest')
      )

      sign_in_and_redirect @user, event: :authentication
    end
  end

end
