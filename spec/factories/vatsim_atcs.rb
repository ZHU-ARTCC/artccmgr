FactoryGirl.define do
  factory :vatsim_atc, class: 'Vatsim::Atc' do
	  association :position
	  association :user
		association :rating

    callsign    { self.position.callsign }
    frequency   { self.position.frequency }
	  latitude    { Faker::Address.latitude }
	  longitude   { Faker::Address.longitude }
	  server      { 'TEST' }
	  range       { rand(400) }
	  logon_time  { Time.now }
	  last_seen   { Time.now }

    trait :invalid do
      user     { nil }
	    position { nil }
    end
  end
end
