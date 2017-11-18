class PositionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized

  def index
    @positions = Position.all
    authorize @positions
  end

  def create
    authorize Position, :create?
    @position = Position.new

    if @position.update_attributes(permitted_attributes(@position))
      redirect_to positions_path, success: 'Position has been saved'
    else
      flash.now[:alert] = 'Unable to save position'
      render :new
    end
  end

  def destroy
    authorize Position, :destroy?
    @position = policy_scope(Position).friendly.find(params[:id])

    if @position.destroy
      redirect_to positions_path, success: 'Position has been deleted'
    else
      redirect_to position_path(@position), alert: 'Unable to delete position'
    end
  end

  def edit
    @position = policy_scope(Position).friendly.find(params[:id])
    authorize @position
  end

  def new
    @position = Position.new

    # Preselect major/minor if parameter is set
    if params['type']
      @position.major = true  if params['type'] == 'major'
      @position.major = false if params['type'] == 'minor'
    end

    authorize @position
  end

  def show
    @position = policy_scope(Position).friendly.find(params[:id])
    authorize @position
  end

  def update
    authorize Position, :update?
    @position = policy_scope(Position).friendly.find(params[:id])

    if @position.update_attributes(permitted_attributes(@position))
      flash[:success] = "#{@position.name} has been updated"
      redirect_to positions_path
    else
      flash.now[:alert] = 'Unable to update position'
      render :edit
    end
  end

end
