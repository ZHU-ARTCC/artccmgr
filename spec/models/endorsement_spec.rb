require 'rails_helper'

RSpec.describe Endorsement, type: :model do

  it 'has a valid factory' do
    expect(build(:endorsement)).to be_valid
  end

  let(:endorsement) { build(:endorsement) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(endorsement).to validate_presence_of(:instructor) }
    it { expect(endorsement).to validate_presence_of(:certification) }
    # it { expect(endorsement).to validate_uniqueness_of(:certification).scoped_to(:user) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(endorsement).to_not allow_value('').for(:instructor) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(endorsement).to belong_to(:certification) }
    it { expect(endorsement).to belong_to(:user) }

  end # describe 'ActiveRecord associations'

	it 'should be uniquely scoped to a user' do
		endorsement = create(:endorsement)
		user = endorsement.user
		cert = endorsement.certification
		expect(build(:endorsement, user: user, certification: cert)).to_not be_valid
	end

end
