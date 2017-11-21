# frozen_string_literal: true

require 'sinatra/base'

class FakeVATUSAForums < Sinatra::Base
  get '/index.php?type=rss&action=.xml' do
    content_type :xml
    status 200
    File.open(Rails.root + 'spec/fixtures/vatusa/forums/rss.xml', 'rb').read
  end
end
