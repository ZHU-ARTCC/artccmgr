# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    before :each do
      Rails.cache.clear
    end

    it 'obtains news articles via RSS' do
      get :index
      expect(assigns(:news)).to be_a_kind_of Array
    end

    it 'handles news RSS download failures' do
      Settings.rss_news_feed = 'https://notaurl'
      get :index
      expect(assigns(:news)).to be_empty
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
