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
    it { expect(user).to validate_presence_of(:rating) }

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

  describe '#activity_report' do
	  it 'returns an array of Vatsim::Atc objects for the user' do
      session = create(:vatsim_atc)
      user    = session.user
		  expect(user.activity_report(session.logon_time, session.last_seen)).to eq [session]
	  end

	  it 'does not return Vatsim::Atc objects for sessions out of the time scope' do
		  session = create(:vatsim_atc, logon_time: (Time.now - 2.days), last_seen: (Time.now - 1.day))
		  user    = session.user
		  expect(user.activity_report((Time.now - 10.minutes), (Time.now - 5.minutes))).to be_empty
	  end

	  it 'orders the associated Vatsim::Atc objects by the last seen time' do
		  session = create(:vatsim_atc, logon_time: (Time.now - 5.minutes), last_seen: Time.now)
		  user    = session.user
      create(:vatsim_atc, user: user, logon_time: (Time.now - 10.minutes), last_seen: (Time.now - 6.minutes))
		  expect(user.activity_report(Time.now - 1.day, Time.now).first).to eq session
	  end
  end

  describe '#initials=' do
	  it 'should capitalize initials' do
		  expect(build(:user, initials: 'tt').initials).to eq 'TT'
	  end

	  it 'should not require unique credentials if preference is set to false' do
		  Settings.unique_operating_initials = false
      create(:user, initials: 'AA')
      expect(build(:user, initials: 'AA')).to be_valid
	  end

	  it 'should require unique credentials if preference is set to true' do
		  Settings.unique_operating_initials = true
		  create(:user, initials: 'AA')
		  expect(build(:user, initials: 'AA')).to_not be_valid
		  Settings.unique_operating_initials = false
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
