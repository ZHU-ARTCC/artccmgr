require 'rails_helper'

RSpec.describe RosterController, type: :controller do

  describe 'GET #index' do
    it 'populates an array of @controllers' do
      local_controller    = create(:user, :local_controller)
      visiting_controller = create(:user, :visiting_controller)
      get :index
      expect(assigns(:controllers)).to eq([local_controller])
      expect(assigns(:visiting_controllers)).to eq([visiting_controller])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @user = create(:user)
    end

    context 'when not logged in' do
      it 'does not delete the user' do
        expect {
          delete :destroy, params: { id: @user }
        }.to_not change(User, :count)
      end
    end

    context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_user_read, :perm_user_delete))
      end

      it 'deletes the user with VATUSA roster removal if requested' do
	      user = create(:user, cid: 1300008) # Use CID in test user pool

	      expect{
		      delete :destroy, params: { id: user, vatusa_remove: '1', vatusa_reason: 'Test' }
	      }.to change(User, :count).by(-1)
      end

      it 'deletes the user without the VATUSA roster removal' do
        expect{
	        delete :destroy, params: { id: @user }
        }.to change(User, :count).by(-1)
      end

      it 'redirects to user#index' do
        delete :destroy, params: { id: @user }
        expect(response).to redirect_to user_index_path
      end
    end
  end

  describe 'GET #edit' do
	  context 'when not logged in' do
      it 'redirects to the root page' do
	      user = create(:user)
        expect(get(:edit, params: {id: user.id})).to redirect_to root_path
      end
	  end

	  context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_user_update))
	      @user = create(:user)
      end

      it 'populates @controller' do
        get :edit, params: { id: @user.id }
        expect(assigns(:user)).to eq(@user)
      end

      it 'renders the :edit view' do
        get :edit, params: { id: @user.id }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user to @user' do
      user = create(:user)
      get :show, params: { id: user }
      expect(assigns(:user)).to eq user
    end

    it 'renders the #show view' do
      get :show, params: { id: create(:user) }
      expect(response).to render_template :show
    end
  end

  describe 'PUT #update' do
    before :each do
      @user = create(:user)
    end

    context 'when not logged in' do
      it 'does not update User' do
        put :update, params: { id: @user, user: attributes_for(:user, initials: 'TS') }
        @user.reload
        expect(@user.initials).to_not eq 'TS'
      end
    end

    context 'valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_user_read, :perm_user_update))
      end

      it 'located the requested @user' do
        put :update, params: { id: @user, user: attributes_for(:user) }
        expect(assigns(:user)).to eq @user
      end

      it "changes @user's attributes" do
        put :update, params: {
            id: @user,
            user: attributes_for(:user, initials: 'FN')
        }
        @user.reload
        expect(@user.initials).to eq 'FN'
      end

      it 'redirects to the updated position' do
        put :update, params: { id: @user, user: attributes_for(:user) }
        expect(response).to redirect_to user_index_path
      end
    end

    context 'invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_user_read, :perm_user_update))
      end

      it 'locates the requested @user' do
        put :update, params: { id: @user, user: attributes_for(:user, :invalid) }
        expect(assigns(:user)).to eq @user
      end

      it "does not change @user's attributes" do
        put :update, params: { id: @user,
                               user: attributes_for(:user, initials: 'FD')
        }

        @user.reload
        expect(@user.initials).to_not be_nil
      end

      it 're-renders the edit method' do
        put :update, params: { id: @user, user: {initials: 'TEST'} }
        expect(response).to render_template :edit
      end
    end
  end

end
