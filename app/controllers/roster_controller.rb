# frozen_string_literal: true

require 'vatusa'

class RosterController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  after_action :verify_authorized

  def index
    @controllers = User.local_controllers
    @visiting_controllers = User.visiting_controllers

    # rubocop:disable LineLength
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

  # rubocop:disable MethodLength, PerceivedComplexity
  def destroy
    authorize User, :destroy?
    @user = policy_scope(User).friendly.find(params[:id])

    if params['vatusa_remove']
      api_url = Rails.application.secrets.vatusa_api_url
      api_key = Rails.application.secrets.vatusa_api_key
      api = VATUSA::API.new(api_url, api_key)
      begin
        api_success = api.roster_delete(@user.cid,
                                        current_user.cid,
                                        params['vatusa_reason'])
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
        redirect_to users_path,
                    alert: 'Unable to delete user locally, removed from VATUSA roster'
      end
    else
      redirect_to users_path,
                  alert: 'Unable to remove user from VATUSA, local remove aborted'
    end
  end
  # rubocop:enable MethodLength, PerceivedComplexity

  # Allows appropriate Roster administrators to delete
  # two-factor authentication for users
  #
  def disable_2fa
    authorize User, :update?
    @user = policy_scope(User).friendly.find(params[:user_id])

    if @user.disable_two_factor!
      flash['success'] = "Two-factor Authentication for #{@user.name_full} disabled."
    else
      flash['alert'] = "Unable to disable two-factor authentication for #{@user.name_full}!"
    end

    redirect_to users_path
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

  # rubocop:disable MethodLength
  def user_info
    authorize User, :create?

    # Look for already saved user information
    user = User.find_by(cid: params[:user_id])

    # Use VATUSA API to lookup CID information if user not found
    if user.nil?
      api = VATUSA::API.new(Rails.application.secrets.vatusa_api_url, Rails.application.secrets.vatusa_api_key)

      begin
        vatusa = api.controller(params[:user_id].to_i)
        rating = Rating.find_by(number: vatusa.rating.to_i)
        user = { name_first: vatusa.fname, name_last: vatusa.lname, email: '', rating: rating.id }
      rescue VATUSA::API::ResponseError
        render json: { status: 'CID not found' }.to_json, status: 200
        return
      end
    else # Guest user was found
      user = { name_first: user.name_first, name_last: user.name_last, email: user.email, rating: user.rating.id }
    end

    respond_to do |format|
      format.json do
        render plain: user.to_h.to_json
      end
    end
  end
  # rubocop:enable MethodLength
end
