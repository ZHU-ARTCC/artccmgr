class FeedbackController < ApplicationController
  before_action :authenticate_user!, except: [:index, :new, :show]

  def index

  end

  def create

  end

  def new
    if user_signed_in?
      @feedback = Feedback.new
    else
      redirect_to user_vatsim_omniauth_authorize_path
    end
  end

end
