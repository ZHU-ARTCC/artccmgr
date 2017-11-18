FactoryGirl.define do
  factory :position do
    sequence(:callsign){ |x| "TST_#{x}_CTR" }
    sequence(:name){ |n| "Position #{n}" }
    sequence(:identification){ |x| "Identification #{x}" }
    sequence(:beacon_codes){ |x| "0000-#{x}" }

    frequency { (('%.1f' % rand(118.0...136.9).round(1).to_s) + ['00', '25', '50', '75'].sample.to_s).to_f }
    major     { [true, false].sample }

    trait :invalid do
      name            { nil }
      frequency       { nil }
      callsign        { nil }
      identification  { nil }
      beacon_codes    { nil }
      major           { nil }
    end

    trait :major do
      major { true }
    end

    trait :minor do
      major { false }
    end
  end
end
