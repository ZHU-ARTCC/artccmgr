class FeedbackController < ApplicationController
  before_action :authenticate_user!, except: [:index, :new, :show]
  after_action :verify_authorized, except: :new

  def index
    #@feedback = Feedback.order(created_at: :desc).page params[:page]
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
      flash.now[:alert] = 'Unable send feedback'
      redirect_to new_feedback_path
    end
  end

  def destroy
  end

  def new
    if user_signed_in?
      @feedback = Feedback.new
      authorize @feedback
    else
      redirect_to user_vatsim_omniauth_authorize_path
    end
  end

  def update
  end

end
