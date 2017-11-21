# frozen_string_literal: true

require 'sinatra/base'

class FakeAirChartsAPI < Sinatra::Base
  get '/v2/Airport/:airport' do
    if params['airport'] == 'KIAH'
      json_response 200, 'KIAH.json'
    else
      airport_not_found(params['airport'])
    end
  end

  private

  def json_response(response_code, airport_icao)
    content_type :json
    status response_code
    File.open(Rails.root + 'spec/fixtures/aircharts/' + airport_icao, 'rb').read
  end

  def airport_not_found(airport_icao)
    content_type :json
    status 404
    { airport_icao.to_s => 'Not Found' }.to_json
  end
end
