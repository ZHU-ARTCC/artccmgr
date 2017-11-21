# frozen_string_literal: true

FactoryGirl.define do
  factory :vatsim_dataserver, class: 'Vatsim::Dataserver' do
    url { Faker::Internet.url }
  end
end
