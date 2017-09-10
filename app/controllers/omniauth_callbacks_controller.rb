class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def vatsim
    @user = User.find_by(cid: request.env['omniauth.auth'].info.id.to_i)

    if @user.present?
      # validate @user, request.env['omniauth.auth']
      sign_in_and_redirect @user, event: :authentication
    else
      #reason = "Member not found on website"
      #set_flash_message(:notice, :failure, kind: 'VATSIM', reason: reason)

      session['devise.vatsim.cid']          = request.env['omniauth.auth'].info.id
      session['devise.vatsim.name_first']   = request.env['omniauth.auth'].info.name_first
      session['devise.vatsim.name_last']    = request.env['omniauth.auth'].info.name_last
      session['devise.vatsim.rating']       = request.env['omniauth.auth'].info.rating
      session['devise.vatsim.pilot_rating'] = request.env['omniauth.auth'].info.pilot_rating
      session['devise.vatsim.email']        = request.env['omniauth.auth'].info.email
      session['devise.vatsim.experience']   = request.env['omniauth.auth'].info.experience
      session['devise.vatsim.reg_date']     = request.env['omniauth.auth'].info.reg_date
      session['devise.vatsim.country']      = request.env['omniauth.auth'].info.country
      session['devise.vatsim.region']       = request.env['omniauth.auth'].info.region
      session['devise.vatsim.division']     = request.env['omniauth.auth'].info.divison
      session['devise.vatsim.subdivision']  = request.env['omniauth.auth'].info.subdivison

      redirect_to new_user_path
    end
  end

  def failure
    redirect_to root_path
  end

end
