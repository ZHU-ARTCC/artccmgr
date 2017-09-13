FactoryGirl.define do
  factory :event_position, class: 'Event::Position' do
    association :event
    association :position

    trait :staffed do
      association :user
    end

  end
end
