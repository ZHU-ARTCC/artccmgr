class FeedbackController < ApplicationController
  before_action :authenticate_user!, except: [:index, :new, :show]
  after_action :verify_authorized, except: :new

  def index
    @feedback = policy_scope(Feedback).page params[:page]
    authorize @feedback
  end

  def create
    authorize Feedback, :create?
    @feedback = Feedback.new

    @feedback.cid   = current_user.cid
    @feedback.name  = current_user.name_full
    @feedback.email = current_user.email

    if @feedback.update_attributes(permitted_attributes(@feedback))
      redirect_to feedback_index_path, success: 'Your feedback has been sent'
    else
      flash.now[:alert] = 'Unable to send feedback'
      render :new
    end
  end

  def destroy
    authorize Feedback, :destroy?
    @feedback = policy_scope(Feedback).find(params[:id])

    if @feedback.destroy
      redirect_to feedback_index_path, success: 'Feedback has been deleted'
    else
      redirect_to feedback_index_path, alert: 'Unable to delete feedback'
    end
  end

  def edit
    @feedback = policy_scope(Feedback).find(params[:id])
    authorize @feedback
  end

  def new
    if user_signed_in?
      @feedback = Feedback.new
      authorize @feedback

      @controllers = User.all_controllers.order(:name_first)
      @positions   = Position.all.order(:callsign)
    else
      redirect_to user_vatsim_omniauth_authorize_path
    end
  end

  def show
    @feedback = policy_scope(Feedback).find(params[:id])
    authorize @feedback
  end

  def update
    authorize Feedback, :update?
    @feedback = policy_scope(Feedback).find(params[:id])

    if @feedback.update_attributes(permitted_attributes(@feedback))
      redirect_to feedback_path(@feedback), success: 'Feedback has been updated'
    else
      flash.now[:alert] = 'Unable to update feedback'
      render :edit
    end
  end

end
