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
        expect {
          post :create, params: { feedback: attributes_for(:feedback) }
        }.to_not change(Feedback, :count)
      end
    end

    context 'with valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_feedback_create))
      end

      it 'creates a new contact' do
        expect {
          post :create, params: { feedback: attributes_for(:feedback) }
        }.to change(Feedback, :count).by 1
      end

      it "redirects to the feedback #index" do
        post :create, params: { feedback: attributes_for(:feedback) }
        expect(response).to redirect_to feedback_index_path
      end
    end

    context 'with invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_feedback_create))
      end

      it 'does not save the new feedback' do
        expect{
          post :create, params: { feedback: attributes_for(:feedback, :invalid) }
        }.to_not change(Feedback,:count)
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
        expect {
          delete :destroy, params: { id: @feedback }
        }.to_not change(Feedback, :count)
      end
    end

    context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_feedback_read, :perm_feedback_delete))
      end

      it 'deletes the feedback' do
        expect{
          delete :destroy, params: { id: @feedback }
        }.to change(Feedback,:count).by(-1)
      end

      it 'redirects to feedback#index' do
        delete :destroy, params: { id: @feedback }
        expect(response).to redirect_to feedback_index_path
      end
    end
  end

  describe "GET #edit" do
    before :each do
      sign_in create(:user, group: create(:group, :perm_feedback_read, :perm_feedback_update))
      @feedback = create(:feedback)
    end

    it 'assigns the requested feedback to @feedback' do
      get :edit, params: { id: @feedback }
      expect(assigns(:feedback)).to eq @feedback
    end

    it 'renders the #edit view' do
      get :edit, params: { id: @feedback }
      expect(response).to render_template :edit
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

    it 'assigns all possible controllers to @controllers' do
      sign_in create(:user, group: create(:group, :perm_feedback_create))
      create_list(:user, 5, :artcc_controller)
      create_list(:user, 3, :visiting_controller)
      get :new
      expect(assigns(:controllers).size).to eq 8
    end

    it 'assigns all possible positions to @positions' do
      sign_in create(:user, group: create(:group, :perm_feedback_create))
      create_list(:position, 10)
      get :new
      expect(assigns(:positions).size).to eq 10
    end

    it 'renders the :new view' do
      sign_in create(:user, group: create(:group, :perm_feedback_create))
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    it 'assigns the requested feedback to @feedback' do
      feedback = create(:feedback, :published)
      get :show, params: { id: feedback }
      expect(assigns(:feedback)).to eq(feedback)
    end

    it 'renders the #show view' do
      get :show, params: { id: create(:feedback, :published) }
      expect(response).to render_template :show
    end
  end

  describe 'PUT #update' do
    before :each do
      @feedback = create(:feedback)
    end

    context 'when not logged in' do
      it 'does not update Feedback' do
        put :update, params: { id: @feedback, feedback: attributes_for(:feedback, name: 'Testing') }
        @feedback.reload
        expect(@feedback.name).to_not eq 'Testing'
      end
    end

    context 'valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_feedback_read, :perm_feedback_update))
      end

      it 'located the requested @feedback' do
        put :update, params: { id: @feedback, feedback: attributes_for(:feedback) }
        expect(assigns(:feedback)).to eq @feedback
      end

      it "changes @feedbacks's attributes" do
        put :update, params: {
            id: @feedback,
            feedback: attributes_for(:feedback, name: "John Smith")
        }
        @feedback.reload
        expect(@feedback.name).to eq 'John Smith'
      end

      it 'redirects to the updated contact' do
        put :update, params: { id: @feedback, feedback: attributes_for(:feedback) }
        expect(response).to redirect_to @feedback
      end
    end

    context 'invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_feedback_read, :perm_feedback_update))
      end

      it 'locates the requested @feedback' do
        put :update, params: { id: @feedback, feedback: attributes_for(:feedback, :invalid) }
        expect(assigns(:feedback)).to eq @feedback
      end

      it "does not change @feedback's attributes" do
        put :update, params: { id: @feedback,
            feedback: attributes_for(:feedback, name: nil)
        }

        @feedback.reload
        expect(@feedback.name).to_not be_nil
      end

      it 're-renders the edit method' do
        put :update, params: { id: @feedback, feedback: attributes_for(:feedback, :invalid) }
        expect(response).to render_template :edit
      end
    end
  end

end
