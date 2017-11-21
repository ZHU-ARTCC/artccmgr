# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    association :rating

    group

    sequence(:cid) { |cid| cid }
    sequence(:name_first) { |x| "First#{x}" }
    sequence(:name_last)  { |y| "Last#{y}"  }

    email     { "#{name_first}.#{name_last}@example.com".downcase }
    reg_date  Time.now.utc

    trait :invalid do
      cid        { nil }
      name_first { nil }
      name_last  { nil }
    end

    trait :gpg_key do
      after(:create) do |user|
        create(:gpg_key, user: user)
      end
    end

    trait :guest do
      group { Group.find_by(name: 'Guest') }
    end

    trait :local_controller do
      group { create(:group, :local_controllers) }
    end

    trait :two_factor_required do
      group { create(:group, :two_factor_required) }
    end

    trait :two_factor_via_otp do
      before(:create) do |user|
        user.otp_required_for_login = true
        user.otp_secret = User.generate_otp_secret(32)
        user.generate_otp_backup_codes!
      end
    end

    trait :two_factor_via_u2f do
      transient { registrations_count 5 }

      after(:create) do |user, evaluator|
        create_list(
          :u2f_registration, evaluator.registrations_count, user: user
        )
      end
    end

    trait :visiting_controller do
      group { create(:group, :visiting_controllers) }
    end
  end
end
