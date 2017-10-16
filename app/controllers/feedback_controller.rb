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

    # Do not set the following parameters if feedback is send anonymously
    unless params['feedback']['anonymous'] == '1'
      @feedback.cid   = current_user.cid
      @feedback.name  = current_user.name_full
      @feedback.email = current_user.email
    end

    if @feedback.update_attributes(permitted_attributes(@feedback))
      flash[:success] = t('feedback.alerts.create.success') unless t('feedback.alerts.create.success').blank?
      redirect_to feedback_index_path
    else
      flash.now[:alert] = t('feedback.alerts.create.errors')
      render :new
    end
  end

  def destroy
    authorize Feedback, :destroy?
    @feedback = policy_scope(Feedback).find(params[:id])

    if @feedback.destroy
      redirect_to feedback_index_path, success: t('feedback.alerts.destroy.success')
    else
      redirect_to feedback_index_path, alert: t('feedback.alerts.destroy.errors')
    end
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
    authorize Feedback, :update?
    @feedback = policy_scope(Feedback).find(params[:id])

    if @feedback.update_attributes(permitted_attributes(@feedback))
      flash[:success] = t('feedback.alerts.update.success')
      redirect_to feedback_index_path
    else
      flash.now[:alert] = t('feedback.alerts.update.errors')
      render :edit
    end
  end

end
