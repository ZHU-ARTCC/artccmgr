class RosterController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized

  def index
    @controllers = User.artcc_controllers.order(:name_last, :name_first)
    @visiting_controllers = User.visiting_controllers.order(:name_last, :name_first)

    @major_certifications = Certification.where(major: true, show_on_roster: true)
    @minor_certifications = Certification.where(major: false, show_on_roster: true)

    authorize @controllers
    authorize @visiting_controllers
  end

  def edit
    @user = policy_scope(User).friendly.find(params[:id])
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
      redirect_to user_index_path
    else
      flash.now[:alert] = 'Unable to update user'
      render :edit
    end
  end

end
