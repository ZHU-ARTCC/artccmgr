FactoryGirl.define do
  factory :event_controller, class: 'Event::Controller' do
    association :event
    association :position

    trait :staffed do
      association :user
    end

  end
end
