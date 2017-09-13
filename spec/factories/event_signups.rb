FactoryGirl.define do
  factory :event_signup, class: 'Event::Signup' do
    association :event
    association :position, factory: :event_position
    association :user
  end
end
