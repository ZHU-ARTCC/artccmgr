require 'rails_helper'

RSpec.describe Event::Signup, type: :model do

  it 'has a valid factory' do
    expect(build(:event_signup)).to be_valid
  end

  let(:event_signup) { build(:event_signup) }

  describe 'ActiveModel validations' do

    # Basic validations
    # belongs_to associations are required by default in Rails 5
    it { expect(event_signup).to validate_presence_of(:user) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(event_signup).to_not allow_value(nil).for(:event) }
    it { expect(event_signup).to_not allow_value(nil).for(:user) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(event_signup).to belong_to(:event) }
    it { expect(event_signup).to belong_to(:user) }
    it { expect(event_signup).to have_many(:requests)}

  end # describe 'ActiveRecord associations'

  it 'prohibits duplicate signup for same event' do
    event_sign_up = create(:event_signup)
    event = event_sign_up.event
    user = event_sign_up.user
    expect(build(:event_signup, event: event, user: user)).to_not be_valid
  end

  it 'prohibits signing up for events after they have ended' do
    event = build(:event, start_time: Time.now + 5.minutes, end_time: Time.now + 10.minutes)
    Timecop.travel(Time.now + 20.minutes)
    expect(build(:event_signup, event: event)).to_not be_valid
  end

end
