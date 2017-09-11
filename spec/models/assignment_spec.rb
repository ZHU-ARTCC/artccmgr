require 'rails_helper'

RSpec.describe Assignment, type: :model do

  it 'has a valid factory' do
    expect(build(:assignment)).to be_valid
  end

  let(:assignment) { build(:assignment) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(assignment).to validate_presence_of(:group) }
    it { expect(assignment).to validate_presence_of(:permission) }

    # Inclusion/acceptance of values
    it { expect(assignment.group).to be_instance_of(Group) }
    it { expect(assignment.permission).to be_instance_of(Permission) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(assignment).to belong_to(:group) }
    it { expect(assignment).to belong_to(:permission) }

  end # describe 'ActiveRecord associations'

end
