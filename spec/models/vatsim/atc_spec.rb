require 'rails_helper'

RSpec.describe Vatsim::Atc, type: :model do

  it 'has a valid factory' do
    expect(build(:vatsim_atc)).to be_valid
  end

  let(:atc) { build(:vatsim_atc) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(atc).to validate_presence_of(:callsign) }
    it { expect(atc).to validate_presence_of(:frequency) }
    it { expect(atc).to validate_presence_of(:server) }
    it { expect(atc).to validate_presence_of(:range) }
    it { expect(atc).to validate_presence_of(:logon_time) }

    # Format validations
    it { expect(atc).to validate_numericality_of(:frequency).is_greater_than_or_equal_to(118).is_less_than(137) }
    it { expect(atc).to validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90) }
    it { expect(atc).to validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180) }
    it { expect(atc).to validate_numericality_of(:range).is_greater_than_or_equal_to(0) }

    # Inclusion/acceptance of values
    it { expect(atc).to_not allow_value('').for(:callsign) }
    it { expect(atc).to_not allow_value('').for(:frequency) }
    it { expect(atc).to_not allow_value('').for(:server) }
    it { expect(atc).to_not allow_value('').for(:range) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(atc).to belong_to(:position) }
    it { expect(atc).to belong_to(:rating) }
    it { expect(atc).to belong_to(:user) }

  end # describe 'ActiveRecord associations'

  describe 'callsign should be forced upper case' do
    it { expect(build(:vatsim_atc, callsign: 'test').callsign).to eq 'TEST' }
  end

end
