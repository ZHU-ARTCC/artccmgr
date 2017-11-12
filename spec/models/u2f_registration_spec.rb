require 'rails_helper'
require 'ostruct'

RSpec.describe U2fRegistration, type: :model do

  it 'has a valid factory' do
    expect(build(:u2f_registration)).to be_valid
  end

  let(:u2f_registration) { build(:u2f_registration) }

  describe 'ActiveRecord associations' do
    it { expect(u2f_registration).to belong_to(:user) }
  end

  describe '#self.register' do
    before do
      @app_id = 'https://localhost'
      @params = { device_response: 'abc', name: 'Key 1' }
      @user   = create(:user)
    end

    context 'success' do
      before :each do
        @reg_data = OpenStruct.new({
          certificate: Faker::Crypto.sha256,
          key_handle:  Faker::Name.first_name,
          public_key:  Faker::Crypto.sha1,
          counter:     0
        })

        allow(U2F::RegisterResponse).to receive(:load_from_json).and_return(true)
        allow_any_instance_of(U2F::U2F).to receive(:register!).and_return(@reg_data)

        @reg = U2fRegistration.register(@user, @app_id, @params, nil)
      end

      it 'registers the U2F device' do
        expect(@reg.persisted?).to be true
      end

      it 'saves the certificate data' do
        expect(@reg.certificate).to eq @reg_data.certificate
      end

      it 'saves the key handle' do
        expect(@reg.key_handle).to eq @reg_data.key_handle
      end

      it 'saves the public key' do
        expect(@reg.public_key).to eq @reg_data.public_key
      end

      it 'saves the counter' do
        expect(@reg.counter).to eq @reg_data.counter
      end

      it 'links the registration to a user' do
        expect(@reg.user).to eq @user
      end

      it 'saves the U2F device name' do
        expect(@reg.name).to eq @params[:name]
      end
    end

    context 'JSON error' do
      before do
        allow(U2F::RegisterResponse).to receive(:load_from_json).and_raise(JSON::ParserError)
        @reg = U2fRegistration.register(@user, @app_id, @params, nil)
      end

      it 'adds a validation error' do
        expect(@reg.errors[:base].first).to eq 'Your U2F device did not send a valid JSON response'
      end
    end

    context 'U2F error' do
      before do
        allow(U2F::RegisterResponse).to receive(:load_from_json).and_return(true)
        allow_any_instance_of(U2F::U2F).to receive(:register!).and_raise(U2F::Error, 'test')
        @reg = U2fRegistration.register(@user, @app_id, @params, nil)
      end

      it 'adds a validation error' do
        expect(@reg.errors[:base].first).to eq 'test'
      end
    end
  end # describe '#self.register'

  describe '#self.authenticate' do
    before do
      @app_id     = 'https://localhost'
      @user       = create(:user, :two_factor_via_u2f)
      @key_handle = @user.u2f_registrations.first.key_handle
    end

    context 'success' do
      before do
        response = OpenStruct.new({key_handle: @key_handle, counter: 1})
        allow(U2F::SignResponse).to receive(:load_from_json).and_return(response)
        allow_any_instance_of(U2F::U2F).to receive(:authenticate!).and_return(true)

        @response = U2fRegistration.authenticate(@user, @app_id, nil, nil)
      end

      it 'updates the counter' do
        registration = @user.u2f_registrations.find_by(key_handle: @key_handle)
        expect(registration.counter).to eq 1
      end

      it 'returns true' do
        expect(@response).to be true
      end
    end

    context 'failure' do
      before do
        response = OpenStruct.new({key_handle: @key_handle, counter: 1})
        allow(U2F::SignResponse).to receive(:load_from_json).and_return(response)
        allow_any_instance_of(U2F::U2F).to receive(:authenticate!).and_raise(U2F::Error, 'test')

        @response = U2fRegistration.authenticate(@user, @app_id, nil, nil)
      end

      it 'returns false' do
        expect(@response).to be false
      end
    end

  end # describe '#self.authenticate'

end
