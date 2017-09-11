require 'rails_helper'

RSpec.describe Permission, type: :model do

  it 'has a valid factory' do
    expect(build(:permission)).to be_valid
  end

  let(:permission) { build(:permission) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(permission).to validate_presence_of(:name) }

    # Inclusion/acceptance of values
    it { expect(permission).to_not allow_value('').for(:name) }
    it { expect(permission).to validate_uniqueness_of(:name) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
  end # describe 'ActiveRecord associations'

  describe '#to_s' do
    it { expect(permission.to_s).to eq permission.name }
  end

end
