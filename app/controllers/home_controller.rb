class HomeController < ApplicationController

  def index
    @events = Event.where('start_time > ?', Time.now).order(start_time: :asc).limit(3)
  end

end
