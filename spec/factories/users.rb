FactoryGirl.define do
  factory :user do
    group

    sequence(:cid){ |cid| cid }
    sequence(:name_first) { |x| "First#{x}" }
    sequence(:name_last)  { |y| "Last#{y}" }

    email     { "#{name_first}.#{name_last}@example.com".downcase }
    rating    'OBS'
    reg_date  Time.now

    trait :controller do
      group { Group.find_or_create_by(name: 'controller') }
    end
  end
end
