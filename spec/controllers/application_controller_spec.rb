# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    def index
      render plain: 'OK'
    end
  end

  describe '#check_two_factor_requirement' do
    context 'when not logged in' do
      it 'should not redirect to the 2FA configuration page' do
        get :index
        expect(response).to_not redirect_to profile_two_factor_auth_path
      end
    end

    context 'when signed in' do
      before do
        sign_in(user)
        allow(subject).to receive(:current_user).and_return(user)
        get :index
      end

      context 'and 2FA is required but not configured' do
        let(:user) { create(:user, :two_factor_required) }

        it 'should redirect to the 2FA configuration page' do
          expect(response).to redirect_to profile_two_factor_auth_path
        end
      end

      context 'and 2FA is required and configured' do
        let(:user) { create(:user, :two_factor_required, :two_factor_via_otp) }

        it 'should not redirect to the 2FA configuration page' do
          expect(response).to_not redirect_to profile_two_factor_auth_path
        end
      end

      context 'and 2FA is not required but is configured' do
        let(:user) { create(:user, :two_factor_via_otp) }

        it 'should not redirect to the 2FA configuration page' do
          expect(response).to_not redirect_to profile_two_factor_auth_path
        end
      end

      context 'and 2FA is not required and not configured' do
        let(:user) { create(:user) }

        it 'should not redirect to the 2FA configuration page' do
          expect(response).to_not redirect_to profile_two_factor_auth_path
        end
      end
    end
  end # describe '#check_two_factor_requirement'
end
