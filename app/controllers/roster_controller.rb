require 'vatusa'

class RosterController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized

  def index
    @controllers = User.local_controllers.order(:name_last, :name_first)
    @visiting_controllers = User.visiting_controllers.order(:name_last, :name_first)

    @major_certifications = Certification.where(major: true, show_on_roster: true)
    @minor_certifications = Certification.where(major: false, show_on_roster: true)

    authorize @controllers
    authorize @visiting_controllers
  end

  def create
    authorize User, :create?

    # Look for potential Guest users to update
    guest = Group.find_by(name: 'Guest')
    @user = User.find_by(cid: params['user']['cid'].to_i, group: guest)

    # If none exists create a new user
    @user = User.new if @user.nil?

    if @user.update_attributes(permitted_attributes(@user))
      redirect_to users_path, success: 'User has been saved'
    else
      flash.now[:alert] = 'Unable to save user'
      render :new
    end
  end

  def destroy
    authorize User, :destroy?
    @user = policy_scope(User).friendly.find(params[:id])

    if params['vatusa_remove']
      api_url = Rails.application.secrets.vatusa_api_url
      api_key = Rails.application.secrets.vatusa_api_key
      api = VATUSA::API.new(api_url, api_key)
      begin
        api_success = api.roster_delete(@user.cid, current_user.cid, params['vatusa_reason'])
      rescue
        api_success = false
      end
    else
      api_success = true
    end

    if api_success
      if @user.destroy
        flash['success'] = 'User has been deleted successfully'
        redirect_to users_path
      else
        redirect_to users_path, alert: 'Unable to delete user locally but user removed from VATUSA roster'
      end
    else
      redirect_to users_path, alert: 'Unable to remove user from VATUSA, local remove aborted'
    end
  end

  def edit
    @user = policy_scope(User).friendly.find(params[:id])
    authorize @user
  end

  def new
    @user = User.new

    # Preselect visiting controller group if parameter is set
    if params['type']
      @user.group = Group.find_by(name: 'Visiting Controller') if params['type'] == 'visiting'
      @user.group = Group.find_by(name: 'Controller') if params['type'] == 'local'
    end

    authorize @user
  end

  def show
    @user = policy_scope(User).friendly.find(params[:id])
    authorize @user
  end

  def update
    @user = policy_scope(User).friendly.find(params[:id])
    authorize @user

    if @user.update_attributes(permitted_attributes(@user))
      flash[:success] = "#{@user.name_full} has been updated"
      redirect_to users_path
    else
      flash.now[:alert] = 'Unable to update user'
      render :edit
    end
  end

end
