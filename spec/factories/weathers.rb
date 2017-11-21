# frozen_string_literal: true

FactoryGirl.define do
  factory :weather do
    association :airport, show_metar: true
    rules     { 'VFR' }
    wind      { '209@07' }
    altimeter { 30.02 }

    metar do
      # rubocop:disable Metrics/LineLength
      'KHWD 280554Z AUTO 29007KT 10SM OVC008 14/12 A3002 RMK AO2 SLP176 T01390117 10211'
      # rubocop:enable Metrics/LineLength
    end
  end
end
