FactoryGirl.define do
  factory :u2f_registration do
	  association :user

    certificate { Faker::Crypto.sha256 }
	  key_handle  { Faker::Crypto.sha256 }
	  public_key  { Faker::Crypto.sha256 }
	  counter     0

	  trait :invalid do
		  certificate { nil }
		  key_handle  { nil }
		  public_key  { nil }
	  end
  end
end
