FactoryGirl.define do
  factory :certification do
    sequence(:name) { |n| "Certification #{n}" }
    positions { create_list(:position, 2, :major) }
  end

  trait :major do
    positions { create_list(:position, 5, :major) }
  end

  trait :minor do
    positions { create_list(:position, 5, :minor) }
  end
end
