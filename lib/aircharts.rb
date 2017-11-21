# frozen_string_literal: true

require 'httparty'
require 'ostruct'

# AirCharts Public API
#
# Initialization: airport = AirCharts::Airport.new('KIWS')
#
# Methods:
#   airport.charts    : Hash of Type => OStuct
#   airport.elevation : 110
#   airport.name      : "West Houston"
#   airport.latitude  : "29.818194"
#   airport.longitude : "-95.672611"
#
# Charts example:
#   airport.charts.keys : ['General', 'SID', 'STAR', 'Approach']
#
#   airport.charts['General'].first.chartname : 'TAKEOFF MINIMUMS'
#
module AirCharts
  class Airport
    include HTTParty
    base_uri 'https://api.aircharts.org/v2'

    attr_reader :response, :info

    def initialize(icao)
      @response = self.class.get("/Airport/#{icao.upcase}")

      unless @response.code == 200
        raise ArgumentError, "ICAO identifier #{icao} not found"
      end

      @info   = OpenStruct.new(@response[icao.upcase]['info'])
      @charts = @response[icao.upcase]['charts']
    end # def initialize

    def charts
      hash = {}

      @charts.collect do |type, array|
        hash[type] = array.collect { |c| OpenStruct.new(c) }
      end

      hash
    end

    def elevation
      @info.elevation
    end

    def name
      @info.name
    end

    def latitude
      @info.latitude
    end

    def longitude
      @info.longitude
    end
  end # class Airport
end # module AirCharts
