require 'rails_helper'

RSpec.describe Event::Controller, type: :model do

  it 'has a valid factory' do
    expect(build(:event_controller)).to be_valid
  end

  let(:event_controller) { build(:event_controller) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(event_controller).to validate_presence_of(:event) }
    it { expect(event_controller).to validate_presence_of(:position) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(event_controller).to_not allow_value(nil).for(:event) }
    it { expect(event_controller).to_not allow_value(nil).for(:position) }

    it { expect(event_controller).to allow_value(nil).for(:user) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(event_controller).to belong_to(:event) }
    it { expect(event_controller).to belong_to(:user) }
    it { expect(event_controller).to belong_to(:position) }

  end # describe 'ActiveRecord associations'

end
