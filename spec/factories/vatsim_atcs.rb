# frozen_string_literal: true

FactoryGirl.define do
  factory :vatsim_atc, class: 'Vatsim::Atc' do
    association :position
    association :user
    association :rating

    callsign    { position.callsign }
    frequency   { position.frequency }
    latitude    { Faker::Address.latitude }
    longitude   { Faker::Address.longitude }
    server      { 'TEST' }
    range       { rand(400) }
    logon_time  { Time.now.utc }
    last_seen   { Time.now.utc }

    trait :invalid do
      user { nil }
      position { nil }
    end
  end
end
