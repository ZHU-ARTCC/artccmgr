require 'rails_helper'

RSpec.describe Profiles::TwoFactorAuths::U2fController, type: :controller do
	before do
		sign_in(user)
		allow(subject).to receive(:current_user).and_return(user)
	end

	describe 'POST #create' do
		let(:user){ create(:user) }
		let(:u2f) { create(:u2f_registration, user: user) }

		context 'success' do
			before do
				allow(U2fRegistration).to receive(:register).and_return(u2f)
				post :create, params: { u2f_registration: { devise_response: 'abc', name: nil } }
			end

			it 'deletes the challenges in the session' do
				expect(session[:challenges]).to be nil
			end

			it 'redirects to the two factor configuration page' do
				expect(response).to redirect_to profile_two_factor_auth_path
			end
		end

		context 'failure' do
			before do
				allow(U2fRegistration).to receive(:register).and_return(u2f)
				allow(u2f).to receive(:persisted?).and_return(false)
				post :create, params: { u2f_registration: { device_response: 'abc', name: nil} }
			end

			it 'redirects to the two factor configuration page' do
				expect(response).to redirect_to profile_two_factor_auth_path
			end
		end
	end # describe 'POST #create'

	describe 'DELETE #destroy' do
		let(:user){ create(:user, :two_factor_via_u2f) }

		context 'success' do
			before do
				@u2f_registration = user.u2f_registrations.first
				post :destroy, params: { id: @u2f_registration }
			end

			it 'deletes the U2F registration' do
				expect(U2fRegistration.find_by(id: @u2f_registration.id)).to be nil
			end

			it 'sets a flash notice' do
				expect(controller).to set_flash[:notice]
			end

			it 'redirects to the two factor configuration page' do
				expect(response).to redirect_to profile_two_factor_auth_path
			end
		end

		context 'failure' do
			before :each do
				allow_any_instance_of(U2fRegistration).to receive(:destroy).and_return(false)
				@u2f_registration = user.u2f_registrations.first
				post :destroy, params: { id: @u2f_registration }
			end

			it 'sets a flash message' do
				expect(controller).to set_flash[:alert]
			end

			it 'redirects to the two factor configuration page' do
				expect(response).to redirect_to profile_two_factor_auth_path
			end
		end
	end # describe 'DELETE #destroy'
end
