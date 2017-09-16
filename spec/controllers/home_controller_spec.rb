require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe 'GET #index' do

    it 'obtains news articles via RSS' do
      get :index
      expect(assigns(:news)).to be_a_kind_of Array
    end

    it 'handles news RSS download failures' do
      Artccmgr::Application::RSS_FEED_URL = 'https://notaurl'
      get :index
      expect(assigns(:news)).to be_a_kind_of Array
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

end
