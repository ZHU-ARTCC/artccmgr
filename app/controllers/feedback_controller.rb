class FeedbackController < ApplicationController
  before_action :authenticate_user!, except: [:index, :new, :show]
  after_action :verify_authorized, except: :new

  def index
    @feedback = Feedback.order(created_at: :desc).page params[:page]
    authorize @feedback
  end

  def create
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
