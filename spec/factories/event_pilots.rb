FactoryGirl.define do
  factory :event_pilot, class: 'Event::Pilot' do
    association :event
    association :user
    sequence(:callsign){|c| "CALLSIGN#{c}"}

    trait :invalid do
      callsign { nil }
    end
  end
end
