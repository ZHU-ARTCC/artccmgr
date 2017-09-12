require 'rails_helper'

RSpec.describe Position, type: :model do

  it 'has a valid factory' do
    expect(build(:position)).to be_valid
  end

  let(:position) { build(:position) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(position).to validate_presence_of(:name) }
    it { expect(position).to validate_presence_of(:frequency) }
    it { expect(position).to validate_presence_of(:callsign) }
    it { expect(position).to validate_presence_of(:identification) }

    # Format validations
    it { expect(position).to validate_uniqueness_of(:callsign).case_insensitive }
    it { expect(position).to validate_length_of(:callsign).is_at_most(11) }
    it { expect(position).to validate_length_of(:beacon_codes).is_at_most(9) }

    it { expect(position).to validate_numericality_of(:frequency).is_greater_than_or_equal_to(118).is_less_than(137) }

    # Inclusion/acceptance of values
    it { expect(position).to_not allow_value('').for(:name) }
    it { expect(position).to_not allow_value('').for(:frequency) }
    it { expect(position).to_not allow_value('').for(:callsign) }
    it { expect(position).to_not allow_value('').for(:identification) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
  end # describe 'ActiveRecord associations'

  describe 'callsign should be forced upper case' do
    it { expect(build(:position, callsign: 'test').callsign).to eq 'TEST' }
  end

end
