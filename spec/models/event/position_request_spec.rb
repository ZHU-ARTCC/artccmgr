# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::PositionRequest, type: :model do
  it 'has a valid factory' do
    expect(build(:event_position_request)).to be_valid
  end

  let(:position_request) { build(:event_position_request) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(position_request).to validate_presence_of(:signup) }
    it { expect(position_request).to validate_presence_of(:position) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(position_request).to_not allow_value(nil).for(:signup) }
    it { expect(position_request).to_not allow_value(nil).for(:position) }
  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
    it { expect(position_request).to belong_to(:signup) }
    it { expect(position_request).to belong_to(:position) }
  end # describe 'ActiveRecord associations'

  describe 'position already requested' do
    it 'should not be allowed to be requested again' do
      request = create(:event_position_request)
      expect(
        build(
          :event_position_request,
          signup: request.signup,
          position: request.position
        )
      ).to_not be_valid
    end
  end
end
