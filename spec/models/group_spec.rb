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

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(group).to have_many(:assignments) }
    it { expect(group).to have_many(:users) }
    it { expect(group).to have_many(:permissions) }

  end # describe 'ActiveRecord associations'

end
