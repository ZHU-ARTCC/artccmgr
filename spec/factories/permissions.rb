FactoryGirl.define do
  factory :permission do
    sequence(:name){ |n| "Permission #{n}" }
  end
end
