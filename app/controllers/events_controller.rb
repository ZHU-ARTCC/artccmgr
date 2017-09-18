class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action { Date.beginning_of_week = :sunday }

  def index
    @events = Event.all.order(start_time: :asc)

    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def create
    authorize Event, :create?
    @event = Event.new

    if @event.update_attributes(permitted_attributes(@event))
      redirect_to event_path(@event), success: 'Event created'
    else
      flash.now[:alert] = 'Unable to create event'
      puts "DEBUG: #{@event.errors.full_messages}"
      render :new
    end
  end

  def destroy
    authorize Event, :destroy?
    @event = policy_scope(Event).find(params[:id])

    if @event.destroy
      redirect_to events_path, success: 'Event has been deleted'
    else
      redirect_to events_path, alert: 'Unable to delete event'
    end
  end

  def edit
    @event = policy_scope(Event).find(params[:id])
    authorize @event
  end

  def new
    @event = Event.new
    @event.event_positions.build
    authorize @event
  end

  def show
    @event = policy_scope(Event).find(params[:id])
    authorize @event
  end

  def update
    authorize Event, :update?
    @event = policy_scope(Event).find(params[:id])

    if @event.update_attributes(permitted_attributes(@event))
      redirect_to event_path(@event), success: 'Event has been updated'
    else
      flash.now[:alert] = 'Unable to update event'
      render :edit
    end
  end

end
