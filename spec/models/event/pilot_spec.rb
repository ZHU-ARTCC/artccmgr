require 'rails_helper'

RSpec.describe Event::Pilot, type: :model do

  it 'has a valid factory' do
    expect(build(:event_pilot)).to be_valid
  end

  let(:event_pilot) { build(:event_pilot) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(event_pilot).to validate_presence_of(:event) }
    it { expect(event_pilot).to validate_presence_of(:user).with_message('must exist') }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(event_pilot).to_not allow_value(nil).for(:event) }
    it { expect(event_pilot).to_not allow_value(nil).for(:user) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(event_pilot).to belong_to(:event) }
    it { expect(event_pilot).to belong_to(:user) }

  end # describe 'ActiveRecord associations'

  describe 'already set as a controller' do

    it 'should not be allowed' do
      controller_sign_up = create(:event_controller)
      event = controller_sign_up.event
      user  = controller_sign_up.user
      expect(build(:event_pilot, event: event, user: user)).to_not be_valid
    end

  end

  describe 'already signed up' do

    it 'should not be allowed to sign up again' do
      event_pilot_sign_up = create(:event_pilot)
      event = event_pilot_sign_up.event
      user  = event_pilot_sign_up.user
      expect(build(:event_pilot, event: event, user: user)).to_not be_valid
    end

  end

end
