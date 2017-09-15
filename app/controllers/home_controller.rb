class HomeController < ApplicationController

  def index
    @events = Event.where('end_time > ?', Time.now).order(start_time: :asc).limit(3)

    Rails.cache.fetch('news-feed', expires_in: 30.minutes) do
      @news = RSS::Parser.parse(open(Artccmgr::Application::RSS_FEED_URL).read, false).items[0..5]
    end
  end

end
