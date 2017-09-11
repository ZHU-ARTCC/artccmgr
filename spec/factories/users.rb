FactoryGirl.define do
  factory :user do
    sequence(:cid){ |cid| cid }
    sequence(:name_first) { |x| "First#{x}" }
    sequence(:name_last)  { |y| "Last#{y}" }

    email     { "#{name_first}.#{name_last}@example.com".downcase }
    rating    'OBS'
    reg_date  Time.now

    group Group.find_by(name: 'guest')
  end
end
