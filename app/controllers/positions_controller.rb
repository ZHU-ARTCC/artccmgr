class PositionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized#, only: [:create, :new, :update, :destroy]

  def index
    @positions = Position.all
    authorize @positions
  end

end
