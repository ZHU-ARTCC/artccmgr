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
    it { expect(user).to validate_presence_of(:reg_date) }
    it { expect(user).to validate_presence_of(:group) }

    # Format validations
    it { expect(user).to validate_numericality_of(:cid) }
    it { expect(user).to validate_length_of(:initials).is_at_most(2) }

    # Inclusion/acceptance of values
    it { expect(user).to_not allow_value('').for(:cid) }
    it { expect(user).to_not allow_value('').for(:name_first) }
    it { expect(user).to_not allow_value('').for(:name_last) }
    it { expect(user).to_not allow_value('').for(:email) }
    it { expect(user).to_not allow_value('').for(:reg_date) }

    it { expect(user).to allow_value('').for(:initials)}

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(user).to belong_to(:group) }
    it { expect(user).to belong_to(:rating) }
    it { expect(user).to have_many(:event_flights).dependent(:destroy) }
    it { expect(user).to have_many(:event_positions) }
    it { expect(user).to have_many(:event_signups).dependent(:destroy) }

    it { expect(user).to have_many(:endorsements).dependent(:destroy) }
    it { expect(user).to have_many(:certifications).through(:endorsements) }
    it { expect(user).to have_many(:positions).through(:certifications) }

  end # describe 'ActiveRecord associations'

  it { should delegate_method(:permissions).to(:group) }
  it { should delegate_method(:staff?).to(:group) }

  describe '#all_controllers' do
    it 'should return all controllers both ARTCC and Visiting' do
      create_list(:user, 2, :local_controller)
      create_list(:user, 3, :visiting_controller)

      expect(User.all_controllers.size).to eq 5
    end
  end

  describe '#local_controllers' do
    it 'should return ARTCC controllers' do
      create_list(:user, 5, :local_controller)
      expect(User.local_controllers.size).to eq 5
    end
  end

  describe '#visiting_controllers' do
    it 'should return Visiting controllers' do
      create_list(:user, 5, :visiting_controller)
      expect(User.visiting_controllers.size).to eq 5
    end
  end

  describe '#initials=' do
	  it 'should capitalize initials' do
		  expect(build(:user, initials: 'tt').initials).to eq 'TT'
	  end
  end

  describe '#is_controller?' do
    it 'should return true when user is a local controller' do
      expect(create(:user, :local_controller).is_controller?).to be true
    end

    it 'should return true when the user is a visiting controller' do
      expect(create(:user, :visiting_controller).is_controller?).to be true
    end

    it 'should return false when user is not a controller' do
      expect(create(:user).is_controller?).to be false
    end
  end

  describe '#name_full' do
    it { expect(user.name_full).to eq "#{user.name_first} #{user.name_last}" }
  end

end
