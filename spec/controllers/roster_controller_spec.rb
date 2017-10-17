require 'rails_helper'

RSpec.describe RosterController, type: :controller do

  describe 'GET #index' do
    it 'populates an array of @controllers' do
      artcc_controller    = create(:user, :artcc_controller)
      visiting_controller = create(:user, :visiting_controller)
      get :index
      expect(assigns(:controllers)).to eq([artcc_controller])
      expect(assigns(:visiting_controllers)).to eq([visiting_controller])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
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

end
