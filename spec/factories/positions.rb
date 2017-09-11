FactoryGirl.define do
  factory :position do
    sequence(:callsign){ |x| "TES_T_#{x}" }
    sequence(:name){ |n| "Position #{n}" }
    sequence(:identification){ |x| "Identification #{x}" }
    sequence(:beacon_codes){ |x| "0000-#{x}" }

    frequency { rand(118.0...137.0).round(3) }
    major     { [true, false].sample }
  end
end
