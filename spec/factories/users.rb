FactoryGirl.define do
  factory :user do
    association :rating

	  group

    sequence(:cid){ |cid| cid }
    sequence(:name_first) { |x| "First#{x}" }
    sequence(:name_last)  { |y| "Last#{y}"  }

    email     { "#{name_first}.#{name_last}@example.com".downcase }
    reg_date  Time.now

    trait :invalid do
      cid        { nil }
      name_first { nil }
      name_last  { nil }
    end

    trait :guest do
      group { Group.find_by(name: 'Guest') }
    end

    trait :local_controller do
      group { create(:group, :local_controllers) }
    end

    trait :visiting_controller do
      group { create(:group, :visiting_controllers)}
    end
  end
end
