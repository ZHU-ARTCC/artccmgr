FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    sequence(:description) { |d| "Description #{d}" }
    start_time { (Time.now + rand(30).days + rand(5).hours).beginning_of_hour }
    end_time   { start_time + 4.hours }
  end

  trait :invalid do
    name { nil }
    description { nil }
    start_time { nil }
    end_time { nil }
  end
end
