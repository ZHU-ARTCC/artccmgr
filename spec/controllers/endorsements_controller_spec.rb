# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EndorsementsController, type: :controller do
  describe 'POST #create' do
    context 'when not logged in' do
      it 'does not create the Endorsement' do
        user = create(:user)
        expect do
          post :create, params: {
            user_id: user.id,
            endorsement: build(:endorsement).attributes
          }
        end.to_not change(Endorsement, :count)
      end
    end

    context 'with valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_endorsement_create))
        @user = create(:user)
      end

      it 'creates a new endorsement' do
        expect do
          post :create, params: {
            user_id: @user.id,
            endorsement: build(:endorsement).attributes
          }
        end.to change(Endorsement, :count).by 1
      end

      it 'redirects to the user #show page' do
        post :create, params: {
          user_id: @user.id,
          endorsement: build(:endorsement).attributes
        }
        expect(response).to redirect_to user_path(@user)
      end
    end

    context 'with invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_endorsement_create))
        @user = create(:user)
      end

      it 'does not save the new certification' do
        expect do
          post :create, params: {
            user_id: @user.id,
            endorsement: build(:endorsement, :invalid).attributes
          }
        end.to_not change(Endorsement, :count)
      end

      it 're-renders the new template' do
        post :create, params: {
          user_id: @user.id,
          endorsement: build(:endorsement, :invalid).attributes
        }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @endorsement = create(:endorsement)
    end

    context 'when not logged in' do
      it 'does not delete the certification' do
        expect do
          delete :destroy, params: {
            user_id: @endorsement.user,
            id: @endorsement
          }
        end.to_not change(Endorsement, :count)
      end
    end

    context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_endorsement_read, :perm_endorsement_delete
        ))
      end

      it 'deletes the endorsement' do
        expect do
          delete :destroy, params: {
            user_id: @endorsement.user,
            id: @endorsement
          }
        end.to change(Endorsement, :count).by(-1)
      end

      it 'redirects to user#show' do
        delete :destroy, params: {
          user_id: @endorsement.user,
          id: @endorsement
        }
        expect(response).to redirect_to user_path(@endorsement.user)
      end

      it 'redirects to #edit if the endorsement cannot be deleted' do
        allow_any_instance_of(Endorsement).to(
          receive(:destroy).and_return(false)
        )
        delete :destroy, params: {
          user_id: @endorsement.user,
          id: @endorsement
        }
        expect(response).to redirect_to(
          edit_user_endorsement_path(@endorsement.user, @endorsement)
        )
      end
    end
  end

  describe 'GET #edit' do
    before :each do
      sign_in create(:user, group: create(
        :group, :perm_endorsement_read, :perm_endorsement_update
      ))
      @endorsement = create(:endorsement)
    end

    it 'assigns the requested endorsement to @endorsement' do
      get :edit, params: { user_id: @endorsement.user, id: @endorsement }
      expect(assigns(:endorsement)).to eq @endorsement
    end

    it 'renders the #edit view' do
      get :edit, params: { user_id: @endorsement.user, id: @endorsement }
      expect(response).to render_template :edit
    end
  end

  describe 'GET #new' do
    before :each do
      sign_in create(:user, group: create(:group, :perm_endorsement_create))
      @user = create(:user)
    end

    it 'assigns the a new endorsement to @endorsement' do
      get :new, params: { user_id: @user }
      expect(assigns(:endorsement)).to be_kind_of Endorsement
    end

    it 'renders the #new view' do
      get :new, params: { user_id: @user }
      expect(response).to render_template :new
    end
  end

  describe 'PUT #update' do
    before :each do
      @endorsement = create(:endorsement)
    end

    context 'when not logged in' do
      it 'does not update Endorsement' do
        put :update, params: {
          user_id: @endorsement.user,
          id: @endorsement,
          endorsement: attributes_for(:endorsement, instructor: 'Testing')
        }
        @endorsement.reload
        expect(@endorsement.instructor).to_not eq 'Testing'
      end
    end

    context 'valid attributes' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_endorsement_read, :perm_endorsement_update
        ))
      end

      it 'located the requested @endorsement' do
        put :update, params: {
          user_id: @endorsement.user,
          id: @endorsement,
          endorsement: attributes_for(:endorsement)
        }
        expect(assigns(:endorsement)).to eq @endorsement
      end

      it 'changes @endorsement\'s attributes' do
        put :update, params: {
          user_id: @endorsement.user,
          id: @endorsement,
          endorsement: attributes_for(:endorsement, instructor: 'Test User')
        }
        @endorsement.reload
        expect(@endorsement.instructor).to eq 'Test User'
      end

      it 'redirects to the updated user profile' do
        put :update, params: {
          user_id: @endorsement.user,
          id: @endorsement,
          endorsement: attributes_for(:endorsement)
        }
        expect(response).to redirect_to user_path(@endorsement.user)
      end
    end

    context 'invalid attributes' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_endorsement_read, :perm_endorsement_update
        ))
      end

      it 'locates the requested @endorsement' do
        put :update, params: {
          user_id: @endorsement.user,
          id: @endorsement,
          endorsement: attributes_for(:endorsement, :invalid)
        }
        expect(assigns(:endorsement)).to eq @endorsement
      end

      it "does not change @endorsement's attributes" do
        put :update, params: {
          user_id: @endorsement.user,
          id: @endorsement,
          endorsement: attributes_for(:endorsement, instructor: nil)
        }

        @endorsement.reload
        expect(@endorsement.instructor).to_not be_nil
      end

      it 're-renders the edit method' do
        put :update, params: {
          user_id: @endorsement.user,
          id: @endorsement,
          endorsement: attributes_for(:endorsement, :invalid)
        }
        expect(response).to render_template :edit
      end
    end
  end
end
