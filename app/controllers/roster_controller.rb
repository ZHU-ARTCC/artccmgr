class RosterController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized

  def index
    @controllers = User.artcc_controllers
    @visiting_controllers = User.visiting_controllers
    authorize @controllers
    authorize @visiting_controllers
  end

end
