FactoryGirl.define do
  factory :event_signup, class: 'Event::Signup' do
    association :event
    association :user

    trait :invalid do
      user { nil }
    end

    trait :assigned_position do
      association :position, factory: :event_position
    end

    trait :with_request do
      association :request, factory: :event_position_request
    end
  end
end
