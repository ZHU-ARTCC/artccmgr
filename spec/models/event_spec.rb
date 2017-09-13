require 'rails_helper'

RSpec.describe Event, type: :model do

  it 'has a valid factory' do
    expect(build(:event)).to be_valid
  end

  let(:event) { build(:event) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(event).to validate_presence_of(:name) }
    it { expect(event).to validate_presence_of(:start_time) }
    it { expect(event).to validate_presence_of(:end_time) }
    it { expect(event).to validate_presence_of(:description) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(event).to_not allow_value('').for(:name) }
    it { expect(event).to_not allow_value('').for(:description) }
    it { expect(event).to_not allow_value('').for(:start_time) }
    it { expect(event).to_not allow_value('').for(:end_time) }

    it { expect(event).to allow_value(Time.now).for(:start_time) }
    it { expect(event).to allow_value(Time.now).for(:end_time) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(event).to have_many(:controllers) }
    it { expect(event).to have_many(:pilots) }
    it { expect(event).to have_many(:sign_ups) }

  end # describe 'ActiveRecord associations'

end
