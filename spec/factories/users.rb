FactoryGirl.define do
  factory :user do
    group

    sequence(:cid){ |cid| cid }
    sequence(:name_first) { |x| "First#{x}" }
    sequence(:name_last)  { |y| "Last#{y}"  }

    email     { "#{name_first}.#{name_last}@example.com".downcase }
    rating    'OBS'
    reg_date  Time.now

    trait :local_controller do
      group { create(:group, :local_controllers) }
    end

    trait :visiting_controller do
      group { create(:group, :visiting_controllers)}
    end
  end
end
