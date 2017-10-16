FactoryGirl.define do
  factory :airport do
    sequence(:icao){ |x| [*'AAAA'..'ZZZZ'][x] }
	  sequence(:name){ |x| "Airport #{x}" }
  end
end
