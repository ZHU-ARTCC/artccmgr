# frozen_string_literal: true

class Events::PilotsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def create
    authorize Event::Pilot, :create?
    @event = Event.friendly.find(params[:event_id])
    @signup = Event::Signup.new(event: @event, user: current_user)
    @pilot  = Event::Pilot.new(event: @event)
    authorize(@pilot)

    @pilot.user = current_user

    if @pilot.update_attributes(permitted_attributes(@pilot))
      redirect_to event_path(@event), success: 'Thank you for signing up!'
    else
      flash.now[:alert] = 'Unable to register you for this event.'
      render 'events/signups/new'
    end
  end

  def destroy
    @event_pilot = Event::Pilot.find(params[:id])
    authorize @event_pilot, :destroy?
    event = @event_pilot.event

    if @event_pilot.destroy
      redirect_to event_path(event),
                  success: 'Your pilot event registration has been deleted'
    else
      redirect_to event_path(event),
                  alert: 'Unable to remove your event registration'
    end
  end
end
