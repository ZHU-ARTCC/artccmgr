FactoryGirl.define do
  factory :assignment do
    association :group
    permission  { Permission.limit(1).order("RANDOM()").first }
  end
end
