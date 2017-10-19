require 'rails_helper'

RSpec.describe Group, type: :model do

  it 'has a valid factory' do
    expect(build(:group)).to be_valid
  end

  let(:group) { build(:group) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(group).to validate_presence_of(:name) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(group).to_not allow_value('').for(:name) }
    it { expect(group).to validate_uniqueness_of(:name).ignoring_case_sensitivity }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(group).to have_many(:assignments) }
    it { expect(group).to have_many(:users) }
    it { expect(group).to have_many(:permissions) }

  end # describe 'ActiveRecord associations'

  describe '#name=' do

	  it 'titleizes the name' do
		  expect(build(:group, name: 'test').name).to eq 'Test'
	  end

  end

  describe 'that have both members of this ARTCC and visiting controllers' do
    # Controllers cannot be both members of the ARTCC and Visiting controllers
    it {
      expect(
        build(:group, artcc_controllers: true, visiting_controllers: true)
      ).to_not be_valid
    }
  end

  describe 'that have members of this ARTCC' do
    # Controllers can be members of the ARTCC
    it {
      expect(
        build(:group, artcc_controllers: true, visiting_controllers: false)
      ).to be_valid
    }
  end

  describe 'that have visiting controllers' do
    # Controllers can be visiting controllers
    it {
      expect(
        build(:group, artcc_controllers: false, visiting_controllers: true)
      ).to be_valid
    }
  end

end
