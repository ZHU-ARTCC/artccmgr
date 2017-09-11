require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  let(:user) { build(:user) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(user).to validate_presence_of(:cid) }
    it { expect(user).to validate_presence_of(:name_first) }
    it { expect(user).to validate_presence_of(:name_last) }
    it { expect(user).to validate_presence_of(:email) }
    it { expect(user).to validate_presence_of(:rating) }
    it { expect(user).to validate_presence_of(:reg_date) }
    it { expect(user).to validate_presence_of(:group) }

    # Format validations
    it { expect(user).to validate_numericality_of(:cid) }
    it { expect(user).to validate_length_of(:initials).is_at_most(2) }
    it { expect(user).to validate_length_of(:rating).is_at_most(3) }

    # Inclusion/acceptance of values
    it { expect(user).to_not allow_value('').for(:cid) }
    it { expect(user).to_not allow_value('').for(:name_first) }
    it { expect(user).to_not allow_value('').for(:name_last) }
    it { expect(user).to_not allow_value('').for(:email) }
    it { expect(user).to_not allow_value('').for(:rating) }
    it { expect(user).to_not allow_value('').for(:reg_date) }

    it { expect(user).to allow_value('').for(:initials)}

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(user).to belong_to(:group) }

  end # describe 'ActiveRecord associations'

  it { should delegate_method(:permissions).to(:group) }

  describe "#name_full" do
    it { expect(user.name_full).to eq "#{user.name_first} #{user.name_last}" }
  end

end
