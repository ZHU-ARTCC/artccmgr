class PositionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized

  def index
    @positions = Position.all
    authorize @positions
  end

end
