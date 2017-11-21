# frozen_string_literal: true

require 'rails_helper'
require 'devise_two_factor/spec_helpers'

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
    it { expect(user).to validate_uniqueness_of(:cid) }
    it { expect(user).to_not allow_value('').for(:cid) }
    it { expect(user).to_not allow_value('').for(:name_first) }
    it { expect(user).to_not allow_value('').for(:name_last) }
    it { expect(user).to_not allow_value('').for(:email) }
    it { expect(user).to_not allow_value('').for(:reg_date) }

    it { expect(user).to allow_value('').for(:initials) }
  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
    it { expect(user).to belong_to(:group) }
    it { expect(user).to belong_to(:rating) }
    it { expect(user).to have_many(:event_flights).dependent(:destroy) }
    it { expect(user).to have_many(:event_positions) }
    it { expect(user).to have_many(:event_signups).dependent(:destroy) }

    it { expect(user).to have_many(:endorsements).dependent(:destroy) }
    it { expect(user).to have_many(:certifications).through(:endorsements) }
    it { expect(user).to have_many(:online_sessions).dependent(:destroy) }
    it { expect(user).to have_many(:positions).through(:certifications) }

    it { expect(user).to have_many(:u2f_registrations).dependent(:destroy) }

    it { expect(user).to have_one(:gpg_key).dependent(:destroy) }
  end # describe 'ActiveRecord associations'

  it { should delegate_method(:atc?).to(:group) }
  it { should delegate_method(:min_controlling_hours).to(:group) }
  it { should delegate_method(:permissions).to(:group) }
  it { should delegate_method(:staff?).to(:group) }
  it { should delegate_method(:two_factor_required?).to(:group) }
  it { should delegate_method(:visiting?).to(:group) }

  # Devise Two Factor Tests
  it_behaves_like 'two_factor_authenticatable' do
    subject { user }
  end

  it_behaves_like 'two_factor_backupable' do
    subject { user }
  end

  describe '#all_controllers' do
    it 'should return all controllers both ARTCC and Visiting' do
      create_list(:user, 2, :local_controller)
      create_list(:user, 3, :visiting_controller)

      expect(User.all_controllers.size).to eq 5
    end
  end

  describe '#disable_two_factor!' do
    before :each do
      @user = create(:user, :two_factor_via_otp, :two_factor_via_u2f)
      @user.disable_two_factor!
      @user.reload
    end

    it 'should reset all OTP settings' do
      expect(@user.otp_required_for_login).to eq false
      expect(@user.encrypted_otp_secret).to eq nil
      expect(@user.encrypted_otp_secret_iv).to eq nil
      expect(@user.encrypted_otp_secret_salt).to eq nil
    end

    it 'should destroy all U2F registrations' do
      expect(@user.u2f_registrations).to be_empty
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

      expect(
        user.activity_report(session.logon_time, session.last_seen)
      ).to eq [session]
    end

    # rubocop:disable Metrics/LineLength
    it 'does not return Vatsim::Atc objects for sessions outside of time scope' do
      # rubocop:enable Metrics/LineLength
      session = create(
        :vatsim_atc,
        logon_time: (Time.now.utc - 2.days),
        last_seen: (Time.now.utc - 1.day)
      )

      user = session.user
      expect(
        user.activity_report(
          (Time.now.utc - 10.minutes),
          (Time.now.utc - 5.minutes)
        )
      ).to be_empty
    end

    it 'orders the associated Vatsim::Atc objects by the last seen time' do
      session = create(
        :vatsim_atc,
        logon_time: (Time.now.utc - 5.minutes),
        last_seen: Time.now.utc
      )

      user = session.user

      create(
        :vatsim_atc,
        user: user,
        logon_time: (Time.now.utc - 10.minutes),
        last_seen: (Time.now.utc - 6.minutes)
      )

      expect(
        user.activity_report(Time.now.utc - 1.day, Time.now.utc).first
      ).to eq session
    end
  end

  describe '#gpg_enabled?' do
    it 'returns true if the user has a GPG key configured' do
      user = create(:user, :gpg_key)
      expect(user.gpg_enabled?).to eq true
    end

    it 'returns false if the user does not have a GPG key enabled' do
      user = create(:user)
      expect(user.gpg_enabled?).to eq false
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

  describe '#is_local?' do
    it 'should return true when the user is a local controller' do
      expect(create(:user, :local_controller).is_local?).to be true
    end

    it 'should return false when the user is a visiting controller' do
      expect(create(:user, :visiting_controller).is_local?).to be false
    end

    it 'should return false when the user is not a controller' do
      expect(create(:user).is_local?).to be false
    end
  end

  describe '#name_first=' do
    it 'should titleize the first name' do
      expect(build(:user, name_first: 'test').name_first).to eq 'Test'
    end
  end

  describe '#name_last=' do
    it 'should titleize the last name' do
      expect(build(:user, name_last: 'test').name_last).to eq 'Test'
    end
  end

  describe '#name_full' do
    it { expect(user.name_full).to eq "#{user.name_first} #{user.name_last}" }
  end

  describe '#two_factor_enabled?' do
    it 'should return true if OTP is enabled' do
      user = create(:user, :two_factor_via_otp)
      expect(user.two_factor_enabled?).to eq true
    end

    it 'should return true if U2F is enabled' do
      user = create(:user, :two_factor_via_u2f)
      expect(user.two_factor_enabled?).to eq true
    end

    it 'should return false if neither OTP or U2F are enabled' do
      user = create(:user)
      expect(user.two_factor_enabled?).to eq false
    end
  end

  describe '#two_factor_otp_enabled?' do
    it 'should return true if OTP is enabled' do
      user = create(:user, :two_factor_via_otp)
      expect(user.two_factor_otp_enabled?).to eq true
    end

    it 'should return false if OTP is disabled' do
      user = create(:user)
      expect(user.two_factor_otp_enabled?).to eq false
    end
  end

  describe '#two_factor_u2f_enabled?' do
    it 'should return true if U2F is enabled' do
      user = create(:user, :two_factor_via_u2f)
      expect(user.two_factor_u2f_enabled?).to eq true
    end

    it 'should return false if U2F is disabled' do
      user = create(:user)
      expect(user.two_factor_u2f_enabled?).to eq false
    end
  end
end
