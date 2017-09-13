FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    sequence(:description) { |d| "Description #{d}" }
    start_time { Time.now }
    end_time   { Time.now + 4.hours }
  end
end
