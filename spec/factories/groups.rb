FactoryGirl.define do
  factory :group do
    sequence(:name){|i| "group #{i}"}
  end
end
