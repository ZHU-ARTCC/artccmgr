# frozen_string_literal: true

FactoryGirl.define do
  factory :event_position_request, class: 'Event::PositionRequest' do
    association :signup, factory: :event_signup
    association :position, factory: :event_position
  end
end
