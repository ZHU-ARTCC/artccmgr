# frozen_string_literal: true

require 'rails_helper'
require 'gitlab/gpg'

RSpec.describe Profiles::GpgKeyController, type: :controller do
  before do
    sign_in(user)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    def go
      post :create, params: { gpg_key: { key: key } }
    end

    context 'with a valid public key' do
      let(:key) { build(:gpg_key, user: nil).key }

      before do
        expect(Gitlab::Gpg).to(
          receive(:fingerprints_from_key).and_return(['ABC123'])
        )

        expect(Gitlab::Gpg).to(
          receive(:primary_keyids_from_key).and_return(['TEST123'])
        )
      end

      it 'enables GPG for the user' do
        go
        user.reload
        expect(user).to be_gpg_enabled
      end

      it 'persists the gpg key' do
        go
        user.reload
        expect(user.gpg_key).to_not be_nil
      end

      it 'redirects to the gpg show page' do
        go
        expect(response).to redirect_to profile_gpg_key_path
      end
    end

    context 'with invalid public key' do
      let(:key) { 'INVALID KEY' }

      it 'has errors' do
        go
        expect(assigns[:gpg_key].errors).to be_present
      end

      it 'renders show' do
        go
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user, :gpg_key) }

    context 'when user has a gpg key' do
      it 'destroys the users gpg key' do
        expect(user.gpg_key).to receive(:destroy)
        delete :destroy
      end
    end

    context 'when user does not have a gpg key' do
      let(:user) { create(:user) }

      it 'does not change the GpgKey table' do
        expect { delete :destroy }.to_not change(GpgKey, :count)
      end
    end

    it 'redirects to profile path' do
      delete :destroy
      expect(response).to redirect_to(profile_path)
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user, :gpg_key) }

    before do
      user
      get :show
    end

    context 'when user has a gpg key' do
      it 'assigns the users gpg key' do
        expect(assigns[:gpg_key]).to eq user.gpg_key
      end
    end

    context 'when user does not have a gpg key' do
      let(:user) { create(:user) }

      it 'instantiates a new gpg key object assigned to the user' do
        expect(assigns[:gpg_key].user).to eq user
        expect(assigns[:gpg_key].key).to be_nil
      end
    end

    it 'renders the show template' do
      expect(response).to render_template :show
    end
  end
end
