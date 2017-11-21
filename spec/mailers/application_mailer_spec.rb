# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  before :each do
    @mailer = ApplicationMailer.new
  end

  it 'defines the default sender address' do
    default_address = "\"#{Settings.artcc_name}\" <#{Settings.mail_from}>"
    expect(@mailer.default_params[:from]).to eq default_address
  end

  describe '#mail' do
    before do
      @result = subject.test(user)
    end

    context 'user without GPG key' do
      let(:user) { create(:user) }

      it 'does not modify the subject' do
        expect(@result.subject).to eq "#{Settings.artcc_name} Notification"
      end

      it 'does not encrypt the body' do
        expect(@result.gpg).to be_nil
      end
    end

    context 'user with GPG key' do
      let(:user) { create(:user, :gpg_key) }

      it 'modifies the subject' do
        expect(
          @result.subject
        ).to eq 'Encrypted Notification from ARTCC Manager'
      end

      it 'encrypts the body' do
        expect(@result.gpg).to_not be_nil
      end

      context 'no signing key configured' do
        before do
          Rails.application.secrets.gpg_key = nil
          Rails.application.secrets.gpg_passphrase = nil
        end

        it 'modifies the subject' do
          expect(
            @result.subject
          ).to eq 'Encrypted Notification from ARTCC Manager'
        end

        it 'encrypts the body' do
          expect(@result.gpg).to_not be_nil
        end
      end
    end
  end # describe '#mail'
end
