class Events::SignupsController < ApplicationController
  before_action :authenticate_user!, except: :new
  after_action :verify_authorized, except: :new

  def create
    authorize Event::Signup, :create?
    @event = Event.friendly.find(params[:event_id])
    @signup = Event::Signup.new(event: @event, user: current_user)
    @pilot  = Event::Pilot.new(event: @event)
    authorize(@signup)

    if @signup.update_attributes(permitted_attributes(@signup))
      redirect_to event_path(@event), success: 'Thank you for signing up!'
    else
      flash.now[:alert] = 'Unable to register you for this event.'
      render :new
    end
  end

  def new
    if user_signed_in?
      @event  = Event.friendly.find(params[:event_id])
      @signup = Event::Signup.new(event: @event)
      @pilot  = Event::Pilot.new(event: @event)

      @signup.requests.build
      @signup.requests.each{|r| r.build_position; r.position.event = @event}
    else
      redirect_to user_vatsim_omniauth_authorize_path
    end
  end

end

