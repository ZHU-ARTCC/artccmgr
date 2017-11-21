# rubocop:disable Style/FrozenStringLiteralComment
# String changes are required for modifying attributes of weather

class MetarJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # Grab all configured airports
    Airport.all.each do |airport|
      begin
        update_metar_for(airport)
      rescue => e
        msg = "MetarJob: Unable to update weather for #{airport.icao}: #{e}"
        Rails.logger.error msg
      end
    end
  end

  # rubocop:disable Metrics/MethodLength
  def update_metar_for(airport)
    # rubocop:disable Rails/DynamicFindBy
    # This find_by method is provided by Metar::Station
    metar = Metar::Station.find_by_cccc(airport.icao)
    # rubocop:enable Rails/DynamicFindBy

    if metar.nil?
      msg = "MetarJob: Unable to retrieve METAR for #{airport.icao}, skipping"
      Rails.logger.error msg
    else
      rules = format_rules(metar.parser.sky_conditions, metar.parser.visibility)

      wind  = format_wind(metar.parser.wind.direction,
                          metar.parser.wind.speed,
                          metar.parser.wind.gusts)

      baro  = format_altimeter(metar.parser.sea_level_pressure)

      # Save to database
      weather = Weather.find_or_initialize_by(airport: airport)
      weather.rules     = rules
      weather.wind      = wind
      weather.altimeter = baro
      weather.metar     = metar.parser.metar
      weather.save
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def format_altimeter(baro)
    baro.raw.sub('A', '').insert(2, '.') unless baro.nil?
  end

  # TODO: Refactor wx rule generation
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  def format_rules(sky_conditions, visibility)
    rules      = ''
    visibility = visibility.to_s(units: :miles).to_i

    # By ceiling
    sky_conditions.each do |conditions|
      layer_type = conditions.quantity.to_s

      layer_height = case conditions.height
                     when nil
                       5000
                     else
                       conditions.height.to_s(units: :feet).to_i
                     end

      # Limited IFR
      if layer_height <= 500
        rules = 'LIFR' if %w[broken overcast].include? layer_type
      # IFR
      elsif layer_height.between?(500, 1000)
        rules = 'IFR' if %w[broken overcast].include? layer_type
      # Marginal VFR
      elsif layer_height.between?(1000, 3000)
        rules = 'MVFR' if %w[broken overcast].include? layer_type
      # Basic VFR
      else
        # rubocop:disable Style/IfInsideElse
        rules = 'VFR' if rules.blank?
        # rubocop:enable Style/IfInsideElse
      end
    end # sky_conditions.each

    # By visibility
    if visibility < 1
      rules = 'LIFR'
    elsif visibility.between?(1, 3)
      rules = 'IFR' if rules.blank? || %w[MVFR VFR].include?(rules)
    elsif visibility.between?(3, 5)
      rules = 'MVFR' if rules.blank? || rules == 'VFR'
    elsif visibility > 5
      rules = 'VFR' if rules.blank?
    end

    rules
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

  # rubocop:disable Metrics/PerceivedComplexity, Metrics/MethodLength
  def format_wind(direction, speed, gusts)
    if direction == :variable_direction
      wind_direction = 'VRB'
    else
      wind_direction = format('%03i', direction.to_f.to_i)
      wind_direction = 360 if wind_direction.to_i.zero?
    end

    wind_speed = speed.to_s(units: :knots).to_i
    gusts.nil? ? wind_gusts = 0 : wind_gusts = gusts.to_s(units: :knots).to_i

    if wind_speed < 3
      wind_string = 'Calm'
    else
      wind_string = "#{wind_direction}@#{wind_speed}"

      if wind_gusts > wind_speed
        wind_string = wind_string.concat "G#{wind_gusts}"
      end
    end

    wind_string
  end
  # rubocop:enable Metrics/PerceivedComplexity, Metrics/MethodLength
end
