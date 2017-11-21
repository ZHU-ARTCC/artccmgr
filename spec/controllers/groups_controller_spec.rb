# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe 'GET #index' do
    context 'when not logged in' do
      it 'redirects to the root_path' do
        get :index
        expect(response).to redirect_to root_path
      end
    end # context 'when not logged in'

    context 'when logged in' do
      context 'without group read permission' do
        before :each do
          sign_in create(:user)
        end

        it 'redirects to the root_path' do
          expect { get :index }.to raise_error(Pundit::NotAuthorizedError)
        end
      end # context 'without group read permission'

      context 'with group read permission' do
        before :each do
          sign_in create(:user, group: create(:group, :perm_group_read))
        end

        it 'assigns groups to @groups' do
          get :index
          expect(assigns(:groups)).to eq Group.all.order(:name)
        end

        it 'renders the index template' do
          get :index
          expect(response).to render_template :index
        end
      end # context 'with group read permission'
    end # context 'when logged in'
  end # describe 'GET #index'

  describe 'POST #create' do
    context 'when not logged in' do
      it 'does not create Group' do
        expect do
          post :create, params: { group: attributes_for(:group) }
        end.to_not change(Group, :count)
      end
    end

    context 'with valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_group_create))
      end

      it 'creates a new group' do
        expect do
          post :create, params: { group: attributes_for(:group) }
        end.to change(Group, :count).by 1
      end

      it 'redirects to the group #index page' do
        group = attributes_for(:group)
        post :create, params: { group: group }
        expect(response).to redirect_to groups_path
      end
    end

    context 'with invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_group_create))
      end

      it 'does not save the new group' do
        expect do
          post :create, params: { group: attributes_for(:group, :invalid) }
        end.to_not change(Group, :count)
      end

      it 're-renders the new template' do
        post :create, params: { group: attributes_for(:group, :invalid) }
        expect(response).to render_template :new
      end
    end
  end # describe 'POST #create'

  describe 'DELETE #destroy' do
    before :each do
      @group = create(:group)
    end

    context 'when not logged in' do
      it 'does not delete the group' do
        expect do
          delete :destroy, params: { id: @group }
        end.to_not change(Group, :count)
      end
    end

    context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_group_read, :perm_group_delete
        ))
      end

      it 'deletes the group' do
        expect do
          delete :destroy, params: { id: @group }
        end.to change(Group, :count).by(-1)
      end

      it 'redirects to group#index' do
        delete :destroy, params: { id: @group }
        expect(response).to redirect_to groups_path
      end

      it 'renders the group#edit template if the group cannot be deleted' do
        allow_any_instance_of(Group).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: @group }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET #edit' do
    context 'when not logged in' do
      it 'redirects to the root_path' do
        get :edit, params: { id: create(:group).friendly_id }
        expect(response).to redirect_to root_path
      end
    end # context 'when not logged in'

    context 'when logged in' do
      context 'without group edit permission' do
        before :each do
          sign_in create(:user)
        end

        it 'redirects to the root_path' do
          expect do
            get :edit, params: { id: create(:group).friendly_id }
          end.to raise_error(Pundit::NotAuthorizedError)
        end
      end # context 'without group create permission'

      context 'with group update permission' do
        before :each do
          sign_in create(:user, group: create(:group, :perm_group_update))
          @group = create(:group)
        end

        it 'assigns the group to @group' do
          get :edit, params: { id: @group.friendly_id }
          expect(assigns(:group)).to eq @group
        end

        it 'renders the edit template' do
          get :edit, params: { id: @group.friendly_id }
          expect(response).to render_template :edit
        end
      end # context 'with group update permission'
    end # context 'when logged in'
  end # describe 'GET #edit'

  describe 'GET #new' do
    context 'when not logged in' do
      it 'redirects to the root_path' do
        get :new
        expect(response).to redirect_to root_path
      end
    end # context 'when not logged in'

    context 'when logged in' do
      context 'without group create permission' do
        before :each do
          sign_in create(:user)
        end

        it 'redirects to the root_path' do
          expect { get :new }.to raise_error(Pundit::NotAuthorizedError)
        end
      end # context 'without group create permission'

      context 'with group create permission' do
        before :each do
          sign_in create(:user, group: create(:group, :perm_group_create))
        end

        it 'assigns a new group to @group' do
          get :new
          expect(assigns(:group)).to be_kind_of Group
        end

        it 'renders the new template' do
          get :new
          expect(response).to render_template :new
        end
      end # context 'with group create permission'
    end # context 'when logged in'
  end # describe 'GET #new'

  describe 'PUT #update' do
    before :each do
      @group = create(:group)
    end

    context 'when not logged in' do
      it 'does not update Group' do
        put :update, params: {
          id: @group,
          group: attributes_for(:group, name: 'Testing')
        }
        @group.reload
        expect(@group.name).to_not eq 'Testing'
      end
    end

    context 'valid attributes' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_group_read, :perm_group_update
        ))
      end

      it 'located the requested @group' do
        put :update, params: { id: @group, group: attributes_for(:group) }
        expect(assigns(:group)).to eq @group
      end

      it 'changes @group attributes' do
        put :update, params: {
          id: @group,
          group: attributes_for(:group, name: 'Test Group')
        }
        @group.reload
        expect(@group.name).to eq 'Test Group'
      end

      it 'redirects to the group #index' do
        put :update, params: { id: @group, group: attributes_for(:group) }
        @group.reload
        expect(response).to redirect_to groups_path
      end
    end

    context 'invalid attributes' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_group_read, :perm_group_update
        ))
      end

      it 'locates the requested @group' do
        put :update, params: { id: @group, group: attributes_for(:group) }
        expect(assigns(:group)).to eq @group
      end

      it 'does not change the @group attributes' do
        put :update, params: { id: @group,
                               group: attributes_for(:group, :invalid) }

        @group.reload
        expect(@group.name).to_not be_nil
      end

      it 're-renders the edit method' do
        put :update, params: {
          id: @group,
          group: attributes_for(:group, :invalid)
        }
        expect(response).to render_template :edit
      end
    end
  end # describe 'PUT #update'
end
