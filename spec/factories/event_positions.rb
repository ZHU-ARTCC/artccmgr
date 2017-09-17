FactoryGirl.define do
  factory :event_position, class: 'Event::Position' do
    association :event
    sequence(:callsign){|c| "Callsign #{c}" }

    trait :staffed do
      association :user
    end

  end
end
