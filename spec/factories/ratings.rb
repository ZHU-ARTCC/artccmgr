FactoryGirl.define do
  factory :rating do
    sequence(:number){|n| n }
	  sequence(:short_name){|s| "T#{s}" }
	  sequence(:long_name){|l| "Test #{l}" }
  end
end
