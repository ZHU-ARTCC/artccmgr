# frozen_string_literal: true

class AirportsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  after_action :verify_authorized

  def index
    @airports = Airport.all.order(:icao)
    authorize @airports
  end

  def create
    authorize Airport, :create?
    @airport = Airport.new

    if @airport.update_attributes(permitted_attributes(@airport))
      redirect_to airports_path, success: 'Airport has been saved'
    else
      flash.now[:alert] = 'Unable to save airport'
      render :new
    end
  end

  def destroy
    authorize Airport, :destroy?
    @airport = policy_scope(Airport).friendly.find(params[:id])

    if @airport.destroy
      redirect_to airports_path, success: 'Airport has been deleted'
    else
      redirect_to airport_path(@airport), alert: 'Unable to delete airport'
    end
  end

  def edit
    @airport = policy_scope(Airport).friendly.find(params[:id])
    authorize @airport
  end

  def new
    @airport = Airport.new
    authorize @airport
  end

  def show
    @airport = policy_scope(Airport).friendly.find(params[:id])
    authorize @airport
  end

  def update
    authorize Airport, :update?
    @airport = policy_scope(Airport).friendly.find(params[:id])

    if @airport.update_attributes(permitted_attributes(@airport))
      flash[:success] = "#{@airport.icao} has been updated"
      redirect_to airports_path
    else
      flash.now[:alert] = 'Unable to update airport'
      render :edit
    end
  end
end
