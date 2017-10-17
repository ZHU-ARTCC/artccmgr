require 'rails_helper'

RSpec.describe PositionsController, type: :controller do

  describe 'GET #index' do
    it 'populates an array of @positions' do
      position = create(:position)
      get :index
      expect(assigns(:positions)).to eq([position])
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
          post :create, params: { position: attributes_for(:position) }
        }.to_not change(Position, :count)
      end
    end

    context 'with valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_position_create))
      end

      it 'creates a new position' do
        expect {
          post :create, params: { position: attributes_for(:position) }
        }.to change(Position, :count).by 1
      end

      it 'redirects to the position #index' do
        post :create, params: { position: attributes_for(:position) }
        expect(response).to redirect_to positions_path
      end
    end

    context 'with invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_position_create))
      end

      it 'does not save the new position' do
        expect{
          post :create, params: { position: attributes_for(:position, :invalid) }
        }.to_not change(Position,:count)
      end

      it 're-renders the new template' do
        post :create, params: { position: attributes_for(:position, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @position = create(:position)
    end

    context 'when not logged in' do
      it 'does not delete the position' do
        expect {
          delete :destroy, params: { id: @position }
        }.to_not change(Position, :count)
      end
    end

    context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_position_read, :perm_position_delete))
      end

      it 'deletes the position' do
        expect{
          delete :destroy, params: { id: @position }
        }.to change(Position,:count).by(-1)
      end

      it 'redirects to position#index' do
        delete :destroy, params: { id: @position }
        expect(response).to redirect_to positions_path
      end
    end
  end

  describe "GET #edit" do
    before :each do
      sign_in create(:user, group: create(:group, :perm_position_read, :perm_position_update))
      @position = create(:position)
    end

    it 'assigns the requested position to @position' do
      get :edit, params: { id: @position }
      expect(assigns(:position)).to eq @position
    end

    it 'renders the #edit view' do
      get :edit, params: { id: @position }
      expect(response).to render_template :edit
    end
  end

  describe "GET #new" do
    before :each do
      sign_in create(:user, group: create(:group, :perm_position_create))
    end

    it 'assigns the a new position to @position' do
      get :new
      expect(assigns(:position)).to be_kind_of Position
    end

    it 'renders the #new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    it 'assigns the requested position to @position' do
      position = create(:position)
      get :show, params: { id: position }
      expect(assigns(:position)).to eq position
    end

    it 'renders the #show view' do
      get :show, params: { id: create(:position) }
      expect(response).to render_template :show
    end
  end

  describe 'PUT #update' do
    before :each do
      @position = create(:position)
    end

    context 'when not logged in' do
      it 'does not update Position' do
        put :update, params: { id: @position, position: attributes_for(:position, name: 'Testing') }
        @position.reload
        expect(@position.name).to_not eq 'Testing'
      end
    end

    context 'valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_position_read, :perm_position_update))
      end

      it 'located the requested @position' do
        put :update, params: { id: @position, position: attributes_for(:position) }
        expect(assigns(:position)).to eq @position
      end

      it "changes @positions's attributes" do
        put :update, params: {
            id: @position,
            position: attributes_for(:position, name: 'Houston Center')
        }
        @position.reload
        expect(@position.name).to eq 'Houston Center'
      end

      it 'redirects to the updated position' do
        put :update, params: { id: @position, position: attributes_for(:position) }
        expect(response).to redirect_to positions_path
      end
    end

    context 'invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_position_read, :perm_position_update))
      end

      it 'locates the requested @position' do
        put :update, params: { id: @position, position: attributes_for(:position, :invalid) }
        expect(assigns(:position)).to eq @position
      end

      it "does not change @position's attributes" do
        put :update, params: { id: @position,
                               position: attributes_for(:position, name: nil)
        }

        @position.reload
        expect(@position.name).to_not be_nil
      end

      it 're-renders the edit method' do
        put :update, params: { id: @position, position: attributes_for(:position, :invalid) }
        expect(response).to render_template :edit
      end
    end
  end

end
