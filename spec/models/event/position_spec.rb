# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::Position, type: :model do
  it 'has a valid factory' do
    expect(build(:event_position)).to be_valid
  end

  let(:event_position) { build(:event_position) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(event_position).to validate_presence_of(:event) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(event_position).to_not allow_value(nil).for(:event) }
    it { expect(event_position).to_not allow_value(nil).for(:callsign) }

    it { expect(event_position).to allow_value(nil).for(:user) }

    # TODO: Fix validation of uniqueness callsign test
    # This validation is producing errors in RSpec Shoulda Matcher
    # it do
    #   expect(event_position).to validate_uniqueness_of(:callsign).
    #       scoped_to(:event).
    #       case_insensitive.
    #       with_message('already assigned to event')
    # end
  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
    it { expect(event_position).to belong_to(:event) }
    it { expect(event_position).to belong_to(:user) }
    it { expect(event_position).to have_many(:requests) }
  end # describe 'ActiveRecord associations'

  describe 'user already assigned' do
    it 'should not be allowed to sign up again' do
      event_position_sign_up = create(:event_position, :staffed)
      event = event_position_sign_up.event
      user  = event_position_sign_up.user
      expect(build(:event_position, event: event, user: user)).to_not be_valid
    end

    it 'should not be allowed to sign up if already an event pilot' do
      pilot_sign_up = create(:event_pilot)
      event = pilot_sign_up.event
      user  = pilot_sign_up.user
      expect(build(:event_position, event: event, user: user)).to_not be_valid
    end
  end

  describe 'position already assigned to event' do
    it 'should not be allowed to be added again' do
      event_position = create(:event_position)
      event = event_position.event
      callsign = event_position.callsign
      expect(
        build(:event_position, callsign: callsign, event: event)
      ).to_not be_valid
    end
  end
end
