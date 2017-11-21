# frozen_string_literal: true

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
    it {
      expect(position).to validate_uniqueness_of(:callsign).case_insensitive
    }

    it { expect(position).to validate_length_of(:callsign).is_at_most(12) }
    it { expect(position).to validate_length_of(:beacon_codes).is_at_most(9) }

    it {
      expect(position).to(
        validate_numericality_of(:frequency)
        .is_greater_than_or_equal_to(118)
        .is_less_than(137)
      )
    }

    # Inclusion/acceptance of values
    it { expect(position).to_not allow_value('').for(:name) }
    it { expect(position).to_not allow_value('').for(:frequency) }
    it { expect(position).to_not allow_value('').for(:callsign) }
    it { expect(position).to_not allow_value('').for(:identification) }
  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
    it { expect(position).to belong_to(:certification) }
  end # describe 'ActiveRecord associations'

  describe 'callsign should be forced upper case' do
    it { expect(build(:position, callsign: 'test').callsign).to eq 'TEST' }
  end

  describe 'callsign should be in valid format' do
    it { expect(build(:position, callsign: 'TESTING')).to_not be_valid }

    # FSS variations
    it { expect(build(:position, callsign: 'TS_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TS_1_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TS_10_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A1_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TS_ABC_FSS')).to be_valid }

    it { expect(build(:position, callsign: 'TST_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_FSS')).to be_valid }

    it { expect(build(:position, callsign: 'TEST_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_1_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_10_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A1_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_ABC_FSS')).to be_valid }

    # Center variations
    it { expect(build(:position, callsign: 'TS_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TS_1_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TS_10_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A1_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TS_ABC_CTR')).to be_valid }

    it { expect(build(:position, callsign: 'TST_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_CTR')).to be_valid }

    it { expect(build(:position, callsign: 'TEST_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_1_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_10_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A1_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_ABC_CTR')).to be_valid }

    # Approach variations
    it { expect(build(:position, callsign: 'TS_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TS_1_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TS_10_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A1_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TS_ABC_APP')).to be_valid }

    it { expect(build(:position, callsign: 'TST_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_APP')).to be_valid }

    it { expect(build(:position, callsign: 'TEST_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_1_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_10_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A1_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_ABC_APP')).to be_valid }

    # Departure variations
    it { expect(build(:position, callsign: 'TS_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TS_1_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TS_10_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A1_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TS_ABC_DEP')).to be_valid }

    it { expect(build(:position, callsign: 'TST_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_DEP')).to be_valid }

    it { expect(build(:position, callsign: 'TEST_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_1_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_10_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A1_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_ABC_DEP')).to be_valid }

    # Tower variations
    it { expect(build(:position, callsign: 'TS_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TS_1_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TS_10_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A1_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TS_ABC_TWR')).to be_valid }

    it { expect(build(:position, callsign: 'TST_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_TWR')).to be_valid }

    it { expect(build(:position, callsign: 'TEST_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_1_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_10_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A1_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_ABC_TWR')).to be_valid }

    # Ground variations
    it { expect(build(:position, callsign: 'TS_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TS_1_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TS_10_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A1_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TS_ABC_GND')).to be_valid }

    it { expect(build(:position, callsign: 'TST_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_GND')).to be_valid }

    it { expect(build(:position, callsign: 'TEST_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_1_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_10_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A1_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_ABC_GND')).to be_valid }

    # Clearance variations
    it { expect(build(:position, callsign: 'TS_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TS_1_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TS_10_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TS_A1_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TS_ABC_DEL')).to be_valid }

    it { expect(build(:position, callsign: 'TST_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_DEL')).to be_valid }

    it { expect(build(:position, callsign: 'TEST_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_1_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_10_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_A1_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TEST_ABC_DEL')).to be_valid }
  end

  describe 'frequency should be a tunable frequency' do
    it { expect(build(:position, frequency: 0.0)).to_not be_valid }

    # 25 kHz spacing with allowance for even numbers (VATSIM requirement)
    it { expect(build(:position, frequency: 118.020)).to be_valid }
    it { expect(build(:position, frequency: 118.025)).to be_valid }
    it { expect(build(:position, frequency: 118.050)).to be_valid }
    it { expect(build(:position, frequency: 118.070)).to be_valid }
    it { expect(build(:position, frequency: 118.075)).to be_valid }
    it { expect(build(:position, frequency: 118.100)).to be_valid }
    it { expect(build(:position, frequency: 118.120)).to be_valid }
    it { expect(build(:position, frequency: 118.125)).to be_valid }
    it { expect(build(:position, frequency: 118.150)).to be_valid }
    it { expect(build(:position, frequency: 118.170)).to be_valid }
    it { expect(build(:position, frequency: 118.175)).to be_valid }
    it { expect(build(:position, frequency: 118.200)).to be_valid }
    it { expect(build(:position, frequency: 118.220)).to be_valid }
    it { expect(build(:position, frequency: 118.225)).to be_valid }
    it { expect(build(:position, frequency: 118.250)).to be_valid }
    it { expect(build(:position, frequency: 118.270)).to be_valid }
    it { expect(build(:position, frequency: 118.275)).to be_valid }
    it { expect(build(:position, frequency: 118.300)).to be_valid }
    it { expect(build(:position, frequency: 118.320)).to be_valid }
    it { expect(build(:position, frequency: 118.325)).to be_valid }
    it { expect(build(:position, frequency: 118.350)).to be_valid }
    it { expect(build(:position, frequency: 118.370)).to be_valid }
    it { expect(build(:position, frequency: 118.375)).to be_valid }
    it { expect(build(:position, frequency: 118.400)).to be_valid }
    it { expect(build(:position, frequency: 118.420)).to be_valid }
    it { expect(build(:position, frequency: 118.425)).to be_valid }
    it { expect(build(:position, frequency: 118.450)).to be_valid }
    it { expect(build(:position, frequency: 118.470)).to be_valid }
    it { expect(build(:position, frequency: 118.475)).to be_valid }
    it { expect(build(:position, frequency: 118.500)).to be_valid }
    it { expect(build(:position, frequency: 118.520)).to be_valid }
    it { expect(build(:position, frequency: 118.525)).to be_valid }
    it { expect(build(:position, frequency: 118.550)).to be_valid }
    it { expect(build(:position, frequency: 118.570)).to be_valid }
    it { expect(build(:position, frequency: 118.575)).to be_valid }
    it { expect(build(:position, frequency: 118.600)).to be_valid }
    it { expect(build(:position, frequency: 118.620)).to be_valid }
    it { expect(build(:position, frequency: 118.625)).to be_valid }
    it { expect(build(:position, frequency: 118.650)).to be_valid }
    it { expect(build(:position, frequency: 118.670)).to be_valid }
    it { expect(build(:position, frequency: 118.675)).to be_valid }
    it { expect(build(:position, frequency: 118.700)).to be_valid }
    it { expect(build(:position, frequency: 118.720)).to be_valid }
    it { expect(build(:position, frequency: 118.725)).to be_valid }
    it { expect(build(:position, frequency: 118.750)).to be_valid }
    it { expect(build(:position, frequency: 118.770)).to be_valid }
    it { expect(build(:position, frequency: 118.775)).to be_valid }
  end

  it 'responds to #to_s with a friendly string' do
    position = build(:position)
    expect(position.to_s).to eq "#{position.callsign} (#{position.frequency})"
  end

  it 'titleizes the identification' do
    position = build(:position, identification: 'test position')
    expect(position.identification).to eq 'Test Position'
  end

  it 'titleizes the name' do
    position = build(:position, name: 'test position')
    expect(position.name).to eq 'Test Position'
  end
end
