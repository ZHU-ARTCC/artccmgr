require 'rails_helper'

RSpec.describe GpgKey, type: :model do

  it 'has a valid factory' do
    expect(build(:gpg_key)).to be_valid
  end

  let(:gpg_key) { build(:gpg_key) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(gpg_key).to validate_presence_of(:user) }
    it { expect(gpg_key).to validate_presence_of(:key) }

  end # describe 'ActiveModel validations'

  describe '#destroy' do
    before do
      gpg_key.save
      @gpg_key = GPGME::Key.find(:public, gpg_key.user.email).first
      # Send a test email to save the user to the local keychain
      ApplicationMailer.test(gpg_key.user.email)
      gpg_key.destroy
    end

    it 'removes the key from the keychain' do
      keys = GPGME::Key.find(:public,gpg_key.user.email)
      expect(keys).to be_empty
    end

  end

end
