# frozen_string_literal: true

require 'sinatra/base'

class FakeVATSIMStatus < Sinatra::Base
  get '/' do
    status 200
    File.open(Rails.root + 'spec/fixtures/vatsim/status', 'rb').read
  end

  get '/vatsim-data.txt' do
    status 200
    File.open(Rails.root + 'spec/fixtures/vatsim/vatsim-data.txt', 'rb').read
  end
end
