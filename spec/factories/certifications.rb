# frozen_string_literal: true

FactoryGirl.define do
  factory :certification do
    sequence(:name) { |n| "Certification #{n}" }
    sequence(:short_name) { |n| "C#{n}" }
    positions { create_list(:position, 2, :major) }
    major { true }
  end

  trait :major do
    positions { create_list(:position, 5, :major) }
  end

  trait :minor do
    major { false }
    positions { create_list(:position, 5, :minor) }
  end
end
