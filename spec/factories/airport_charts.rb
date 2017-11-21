# frozen_string_literal: true

FactoryGirl.define do
  factory :airport_chart, class: 'Airport::Chart' do
    association :airport

    sequence(:name) { |n| "Chart #{n}" }
    sequence(:url) { |u| "https://example.com/charts/#{u}" }
    category { 'TEST' }
  end
end
