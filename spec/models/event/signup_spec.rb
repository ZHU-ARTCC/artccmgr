require 'rails_helper'

RSpec.describe Event::Signup, type: :model do

  it 'has a valid factory' do
    expect(build(:event_signup)).to be_valid
  end

  let(:event_signup) { build(:event_signup) }

  describe 'ActiveModel validations' do

    # Basic validations
    # belongs_to associations are required by default in Rails 5
    # it { expect(event_signup).to validate_presence_of(:position) }
    # it { expect(event_signup).to validate_presence_of(:user) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(event_signup).to_not allow_value(nil).for(:event) }
    it { expect(event_signup).to_not allow_value(nil).for(:position) }
    it { expect(event_signup).to_not allow_value(nil).for(:user) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(event_signup).to belong_to(:event) }
    it { expect(event_signup).to belong_to(:position) }
    it { expect(event_signup).to belong_to(:user) }

  end # describe 'ActiveRecord associations'


  it 'prohibits duplicate signup for same position' do
    event_sign_up = create(:event_signup)
    event = event_sign_up.event
    position = event_sign_up.position
    user = event_sign_up.user
    expect(build(:event_signup, event: event, position: position, user: user)).to_not be_valid
  end

  it 'allows signup for more than one position at same event' do
    event_sign_up = create(:event_signup)
    position = create(:event_position, event: event_sign_up.position.event)
    user = event_sign_up.user
    expect(build(:event_signup, position: position, user: user)).to be_valid
  end

end
