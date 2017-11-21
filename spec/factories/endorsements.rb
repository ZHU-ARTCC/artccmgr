# frozen_string_literal: true

FactoryGirl.define do
  factory :endorsement do
    association :certification
    association :user

    sequence(:instructor) { |x| "Instructor #{x}" }

    trait :invalid do
      user { nil }
      certification { nil }
      instructor { nil }
    end

    trait :solo do
      solo { true }
    end
  end
end
