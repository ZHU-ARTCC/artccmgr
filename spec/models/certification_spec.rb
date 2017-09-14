require 'rails_helper'

RSpec.describe Certification, type: :model do

  it 'has a valid factory' do
    expect(build(:certification)).to be_valid
  end

  let(:certification) { build(:certification) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(certification).to validate_presence_of(:name) }

    # Format validations
    it { expect(certification).to validate_uniqueness_of(:name).case_insensitive }

    # Inclusion/acceptance of values
    it { expect(certification).to_not allow_value('').for(:name) }
    # it { expect(certification).to validate_length_of(:positions).is_at_least(1) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(certification).to have_many(:positions) }

  end # describe 'ActiveRecord associations'

  it 'cannot have both major and minor positions' do
    major_positions = create_list(:position, 3, :major)
    minor_positions = create_list(:position, 3, :minor)
    expect(build(:certification, positions: major_positions.concat(minor_positions))).to_not be_valid
  end

  it 'must contain at least one position' do
    expect(build(:certification, positions: [])).to_not be_valid
  end

end
