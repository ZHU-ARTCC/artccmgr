# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Certification, type: :model do
  it 'has a valid factory' do
    expect(build(:certification)).to be_valid
  end

  let(:certification) { build(:certification) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(certification).to validate_presence_of(:name) }
    it { expect(certification).to validate_presence_of(:short_name) }

    # Format validations
    it {
      expect(certification).to(
        validate_uniqueness_of(:name)
        .scoped_to(:major)
        .ignoring_case_sensitivity
      )
    }

    # Inclusion/acceptance of values
    it { expect(certification).to_not allow_value('').for(:name) }
    it { expect(certification).to_not allow_value('').for(:short_name) }
  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
    it { expect(certification).to have_many(:positions) }
    it { expect(certification).to have_many(:endorsements) }
    it { expect(certification).to have_many(:users).through(:endorsements) }
  end # describe 'ActiveRecord associations'

  it 'cannot have both major and minor positions' do
    major_positions = create_list(:position, 3, :major)
    minor_positions = create_list(:position, 3, :minor)

    expect(
      build(:certification, positions: major_positions.concat(minor_positions))
    ).to_not be_valid
  end

  it 'titleizes the name' do
    expect(build(:certification, name: 'test certification').name).to(
      eq 'Test Certification'
    )
  end

  it 'up cases the short name' do
    expect(build(:certification, short_name: 'test').short_name).to eq 'TEST'
  end
end
