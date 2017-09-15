class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :store_current_location, unless: :devise_controller?
  #before_action :metar, unless: :devise_controller?

  private

  # obtain the latest METAR
  def metar
    Rails.cache.fetch('metar', expires_in: 1.hour) do
      @metar   = {}
      stations = ['KIAH', 'KHOU', 'KSAT', 'KCRP']

      stations.each do |station|
        metar = Metar::Station.find_by_cccc(station)

        rules = 'IFR'

        # Wind
        wind_speed = metar.parser.wind.speed.to_s(units: :knots).to_i

        if metar.parser.wind.gusts.nil?
          wind_gusts = 0
        else
          wind_gusts = metar.parser.wind.gusts.to_s(units: :knots).to_i
        end

        if wind_speed < 3
          wind = 'Calm'
        else
          wind = "#{metar.parser.wind.direction.to_f.to_i}@#{wind_speed}"

          if wind_gusts > wind_speed
            wind = wind.concat "G#{wind_gusts}"
          end
        end

        # Baro
        baro = metar.parser.sea_level_pressure.raw.sub('A', '').insert(2, '.')

        @metar[station] = {rules: rules, wind: wind, baro: baro, raw: metar.parser.raw.metar}
      end
    end
  end

  # override the devise helper to store the current location so we can
  # redirect to it after logging in or out. This override makes signing in
  # and signing up work automatically.
  def store_current_location
    store_location_for(:user, request.url)
  end

end
