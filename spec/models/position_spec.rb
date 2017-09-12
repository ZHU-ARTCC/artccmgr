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

  describe 'callsign should be in valid format' do
    it { expect(build(:position, callsign: 'TESTING')).to_not be_valid }

    # FSS variations
    it { expect(build(:position, callsign: 'TST_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_FSS')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_FSS')).to be_valid }

    # Center variations
    it { expect(build(:position, callsign: 'TST_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_CTR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_CTR')).to be_valid }

    # Approach variations
    it { expect(build(:position, callsign: 'TST_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_APP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_APP')).to be_valid }

    # Departure variations
    it { expect(build(:position, callsign: 'TST_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_DEP')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_DEP')).to be_valid }

    # Tower variations
    it { expect(build(:position, callsign: 'TST_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_TWR')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_TWR')).to be_valid }

    # Ground variations
    it { expect(build(:position, callsign: 'TST_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_GND')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_GND')).to be_valid }

    # Clearance variations
    it { expect(build(:position, callsign: 'TST_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TST_1_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TST_10_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TST_A1_DEL')).to be_valid }
    it { expect(build(:position, callsign: 'TST_ABC_DEL')).to be_valid }
  end

end
