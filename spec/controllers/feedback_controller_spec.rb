# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedbackController, type: :controller do
  describe 'GET #index' do
    it 'populates an array of @feedback' do
      feedback = create(:feedback, :published)
      get :index
      expect(assigns(:feedback)).to eq([feedback])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    context 'when not logged in' do
      it 'does not create Feedback' do
        expect do
          post :create, params: { feedback: attributes_for(:feedback) }
        end.to_not change(Feedback, :count)
      end
    end

    context 'with valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_feedback_create))
      end

      it 'creates a new contact' do
        expect do
          post :create, params: { feedback: attributes_for(:feedback) }
        end.to change(Feedback, :count).by 1
      end

      it 'redirects to the feedback #index' do
        post :create, params: { feedback: attributes_for(:feedback) }
        expect(response).to redirect_to feedback_index_path
      end
    end

    context 'with invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_feedback_create))
      end

      it 'does not save the new feedback' do
        expect do
          post :create, params: {
            feedback: attributes_for(:feedback, :invalid)
          }
        end.to_not change(Feedback, :count)
      end

      it 're-renders the new template' do
        post :create, params: { feedback: attributes_for(:feedback, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @feedback = create(:feedback)
    end

    context 'when not logged in' do
      it 'does not delete Feedback' do
        expect do
          delete :destroy, params: { id: @feedback }
        end.to_not change(Feedback, :count)
      end
    end

    context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_feedback_read, :perm_feedback_delete
        ))
      end

      it 'deletes the feedback' do
        expect do
          delete :destroy, params: { id: @feedback }
        end.to change(Feedback, :count).by(-1)
      end

      it 'redirects to feedback#index' do
        delete :destroy, params: { id: @feedback }
        expect(response).to redirect_to feedback_index_path
      end

      it 'redirects to feedback#index even if the feedback cannot be deleted' do
        allow_any_instance_of(Feedback).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: @feedback }
        expect(response).to redirect_to feedback_index_path
      end
    end
  end

  describe 'GET #new' do
    it 'redirects to login if no user logged in' do
      get :new
      expect(response).to redirect_to(user_vatsim_omniauth_authorize_path)
    end

    it 'assigns a new Feedback object' do
      sign_in create(:user, group: create(:group, :perm_feedback_create))
      get :new
      expect(assigns(:feedback)).to be_kind_of Feedback
    end

    it 'renders the :new view' do
      sign_in create(:user, group: create(:group, :perm_feedback_create))
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'PUT #update' do
    before :each do
      @feedback = create(:feedback)
    end

    context 'when not logged in' do
      it 'does not update Feedback' do
        put :update, params: {
          id: @feedback,
          feedback: attributes_for(:feedback, name: 'Testing')
        }
        @feedback.reload
        expect(@feedback.name).to_not eq 'Testing'
      end
    end

    context 'valid attributes' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_feedback_read, :perm_feedback_update
        ))
      end

      it 'located the requested @feedback' do
        put :update, params: {
          id: @feedback,
          feedback: attributes_for(:feedback)
        }
        expect(assigns(:feedback)).to eq @feedback
      end

      it 'changes @feedbacks\'s attributes' do
        put :update, params: {
          id: @feedback,
          feedback: attributes_for(:feedback, name: 'John Smith')
        }
        @feedback.reload
        expect(@feedback.name).to eq 'John Smith'
      end

      it 'redirects to the updated feedback' do
        put :update, params: {
          id: @feedback,
          feedback: attributes_for(:feedback)
        }
        expect(response).to redirect_to feedback_index_path
      end
    end

    context 'invalid attributes' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_feedback_read, :perm_feedback_update
        ))
      end

      it 'locates the requested @feedback' do
        put :update, params: {
          id: @feedback,
          feedback: attributes_for(:feedback, :invalid)
        }
        expect(assigns(:feedback)).to eq @feedback
      end

      it 'does not change @feedback\'s attributes' do
        put :update, params: { id: @feedback,
                               feedback: attributes_for(:feedback, name: nil) }

        @feedback.reload
        expect(@feedback.name).to_not be_nil
      end

      it 're-renders the edit method' do
        put :update, params: {
          id: @feedback,
          feedback: attributes_for(:feedback, :invalid)
        }
        expect(response).to render_template :edit
      end
    end
  end
end
