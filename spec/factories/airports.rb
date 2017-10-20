FactoryGirl.define do
  factory :airport do
    sequence(:icao){ |x| [*'AAAA'..'ZZZZ'][x] }
	  sequence(:name){ |x| "Airport #{x}" }

    trait :invalid do
      icao { nil }
      name { nil }
    end
  end
end
