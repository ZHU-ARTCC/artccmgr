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

  describe 'POST #create' do
    context 'when not logged in' do
      it 'does not create Position' do
        expect {
          post :create, params: { user: attributes_for(:user) }
        }.to_not change(User, :count)
      end
    end

    context 'with valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_user_create))
        @user = build(:user)
      end

      context 'and an existing Guest user' do
        before :each do
          @guest = create(:user, :guest)
        end

        it 'locates the guest user' do
          post :create, params: { user: @guest.attributes }
          expect(assigns(:user)).to eq(@guest)
        end

        it 'updates the user' do
          @guest.name_first = 'Test'
          post :create, params: { user: @guest.attributes}
          @guest.reload
          expect(@guest.name_first).to eq 'Test'
        end

        it 'redirects to the user #index' do
          post :create, params: { user: @guest.attributes }
          expect(response).to redirect_to users_path
        end
      end # context 'with an existing Guest user'

      context 'with user that does not exist' do
        it 'creates a new user' do
          expect {
            post :create, params: { user: @user.attributes }
          }.to change(User, :count).by 1
        end

        it 'redirects to the user #index' do
          post :create, params: { user: @user.attributes }
          expect(response).to redirect_to users_path
        end
      end # context 'with user that does not exist'
    end

    context 'with invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_user_create))
      end

      it 'does not save the new user' do
        expect{
          post :create, params: { user: attributes_for(:user, :invalid) }
        }.to_not change(User,:count)
      end

      it 're-renders the new template' do
        post :create, params: { user: attributes_for(:user, :invalid) }
        expect(response).to render_template :new
      end
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

      context 'with VATUSA roster removal requested' do
        before :each do
          @user = create(:user, cid: 1300008) # Use CID in test user pool
        end

        context 'when API call succeeds' do

          it 'deletes the user locally' do
            expect{
              delete :destroy, params: { id: @user, vatusa_remove: '1', vatusa_reason: 'Test' }
            }.to change(User, :count).by(-1)
          end

        end # context 'when API call succeeds'

        context 'when API call fails' do

          it 'does not delete the user locally' do
            allow_any_instance_of(VATUSA::API).to receive(:roster_delete).and_raise(StandardError)
            expect{
              delete :destroy, params: { id: @user, vatusa_remove: '1', vatusa_reason: 'Test' }
            }.to_not change(User, :count)
          end

        end # context 'when API call fails'

      end # context 'with VATUSA roster removal requested'

      it 'deletes the user without the VATUSA roster removal' do
        expect{
	        delete :destroy, params: { id: @user }
        }.to change(User, :count).by(-1)
      end

      it 'redirects to users#index if the user cannot be deleted' do
        allow_any_instance_of(User).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: @user }
        expect(response).to redirect_to users_path
      end

      it 'redirects to user#index' do
        delete :destroy, params: { id: @user }
        expect(response).to redirect_to users_path
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

  describe 'GET #new' do
    before :each do
      sign_in create(:user, group: create(:group, :perm_user_create))
    end

    context 'when local controller is specified' do
      it 'presets the users group to Controller' do
        get :new, params: { type: :local }
        expect(assigns(:user).group).to eq Group.find_by(name: 'Controller')
      end
    end

    context 'when visiting controller is specified' do
      it 'presets the users group to Visiting Controller' do
        get :new, params: { type: :visiting }
        expect(assigns(:user).group).to eq Group.find_by(name: 'Visiting Controller')
      end
    end

    it 'assigns the a new user to @user' do
      get :new
      expect(assigns(:user)).to be_kind_of User
    end

    it 'renders the #new view' do
      get :new
      expect(response).to render_template :new
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
        expect(response).to redirect_to users_path
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
