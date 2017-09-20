FactoryGirl.define do
  factory :event_pilot, class: 'Event::Pilot' do
    association :event
    association :user
    sequence(:callsign){|c| "CALLSIGN#{c}"}
  end
end
