FactoryGirl.define do
  factory :position do
    sequence(:callsign){ |x| "TST_#{x}_CTR" }
    sequence(:name){ |n| "Position #{n}" }
    sequence(:identification){ |x| "Identification #{x}" }
    sequence(:beacon_codes){ |x| "0000-#{x}" }

    frequency { (('%.1f' % rand(118.0...136.9).round(1).to_s) + ['00', '25', '50', '75'].sample.to_s).to_f }
    major     { [true, false].sample }
  end
end
