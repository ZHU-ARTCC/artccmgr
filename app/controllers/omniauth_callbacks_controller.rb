class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # Callback method to handle SSO failures
  #
  def failure
    set_flash_message(:notice, :failure, kind: 'VATSIM', reason: 'OAuth failure.')
    redirect_to root_path
  end

  # Callback method to handle the SSO callback from Omniauth/VATSIM SSO
  #
  def vatsim
    sso_data = request.env['omniauth.auth']
    sso_info = sso_data.info

    @user = User.find_by(cid: request.env['omniauth.auth'].info.id.to_i)

    if @user.present?
      # Check for changes since last login
      reconcile_vatsim_data(@user, sso_info)

      # Sign in to website
      sign_in_and_redirect @user, event: :authentication
    else
      #reason = "Member not found on website"
      #set_flash_message(:notice, :failure, kind: 'VATSIM', reason: reason)

      # Create a new User object
      @user = User.new

      # Update the User object with VATSIM SSO data
      reconcile_vatsim_data(@user, sso_info)

      # Sign in to website
      sign_in_and_redirect @user, event: :authentication
    end
  end

  private

  # Reconcile VATSIM data with local user data
  #
  def reconcile_vatsim_data(user, vatsim)
    # If this is not a new user, we do not want to change CID or Group
    unless user.persisted?
      user.cid      = vatsim.id.to_i
      user.group    = Group.find_by(name: 'Guest')
    end

    user.name_first = vatsim.name_first
    user.name_last  = vatsim.name_last
    user.email      = vatsim.email
    user.rating     = Rating.find_by(number: vatsim.rating.id.to_i)
    user.reg_date   = vatsim.reg_date

    user.save if user.changed?
  end

end
