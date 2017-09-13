FactoryGirl.define do
  factory :event_pilot, class: 'Event::Pilot' do
    association :event
    association :user
  end
end
