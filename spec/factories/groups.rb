FactoryGirl.define do
  factory :group do
    sequence(:name){|i| "group #{i}"}

    trait :controller do
      name { 'controller' }
    end
  end
end
