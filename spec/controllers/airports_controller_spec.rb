# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AirportsController, type: :controller do
  before :all do
    # Disable the ActiveJob queue due to the create callback firing
    # the AirportUpdateJob. The job is tested in it's own RSpec
    ActiveJob::Base.queue_adapter = :test
  end

  describe 'GET #index' do
    it 'populates an array of @airports' do
      airport = create(:airport)
      get :index
      expect(assigns(:airports)).to eq([airport])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    context 'when not logged in' do
      it 'does not create the Airport' do
        expect do
          post :create, params: { airport: attributes_for(:airport) }
        end.to_not change(Airport, :count)
      end
    end

    context 'with valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_airport_create))
      end

      it 'creates a new airport' do
        expect do
          post :create, params: { airport: attributes_for(:airport) }
        end.to change(Airport, :count).by 1
      end

      it 'redirects to the airport #index' do
        post :create, params: { airport: attributes_for(:airport) }
        expect(response).to redirect_to airports_path
      end
    end

    context 'with invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_airport_create))
      end

      it 'does not save the new airport' do
        expect do
          post :create, params: { airport: attributes_for(:airport, :invalid) }
        end.to_not change(Airport, :count)
      end

      it 're-renders the new template' do
        post :create, params: { airport: attributes_for(:airport, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @airport = create(:airport)
    end

    context 'when not logged in' do
      it 'does not delete the airport' do
        expect do
          delete :destroy, params: { id: @airport }
        end.to_not change(Airport, :count)
      end
    end

    context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_airport_read, :perm_airport_delete
        ))
      end

      it 'deletes the airport' do
        expect do
          delete :destroy, params: { id: @airport }
        end.to change(Airport, :count).by(-1)
      end

      it 'redirects to airport#index' do
        delete :destroy, params: { id: @airport }
        expect(response).to redirect_to airports_path
      end

      it 'redirects to airport#show if the airport cannot be deleted' do
        allow_any_instance_of(Airport).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: @airport }
        expect(response).to redirect_to airport_path(@airport)
      end
    end
  end

  describe 'GET #edit' do
    context 'when not logged in' do
      it 'redirects to the root page' do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_airport_read, :perm_airport_update
        ))
        @airport = create(:airport)
      end

      it 'assigns the requested airport to @airport' do
        get :edit, params: { id: @airport }
        expect(assigns(:airport)).to eq @airport
      end

      it 'renders the #edit view' do
        get :edit, params: { id: @airport }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #new' do
    context 'when not logged in' do
      it 'redirects to the root page' do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_airport_create))
      end

      it 'assigns the a new airport to @airport' do
        get :new
        expect(assigns(:airport)).to be_kind_of Airport
      end

      it 'renders the #new view' do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested airport to @airport' do
      airport = create(:airport)
      get :show, params: { id: airport }
      expect(assigns(:airport)).to eq airport
    end

    it 'renders the #show view' do
      get :show, params: { id: create(:airport) }
      expect(response).to render_template :show
    end
  end

  describe 'PUT #update' do
    before :each do
      @airport = create(:airport)
    end

    context 'when not logged in' do
      it 'does not update Airport' do
        put :update, params: {
          id: @airport,
          airport: attributes_for(:airport, name: 'Testing')
        }
        @airport.reload
        expect(@airport.name).to_not eq 'Testing'
      end
    end

    context 'valid attributes' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_airport_read, :perm_airport_update
        ))
      end

      it 'located the requested @airport' do
        put :update, params: { id: @airport, airport: attributes_for(:airport) }
        expect(assigns(:airport)).to eq @airport
      end

      it 'changes @airport\'s attributes' do
        put :update, params: {
          id: @airport,
          airport: attributes_for(:airport, name: 'Houston Airport')
        }
        @airport.reload
        expect(@airport.name).to eq 'Houston Airport'
      end

      it 'redirects to the updated airport' do
        put :update, params: { id: @airport, airport: attributes_for(:airport) }
        expect(response).to redirect_to airports_path
      end
    end

    context 'invalid attributes' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_airport_read, :perm_airport_update
        ))
      end

      it 'locates the requested @airport' do
        put :update, params: {
          id: @airport, airport: attributes_for(:airport, :invalid)
        }
        expect(assigns(:airport)).to eq @airport
      end

      it "does not change @airport's attributes" do
        put :update, params: { id: @airport,
                               airport: attributes_for(:airport, name: nil) }

        @airport.reload
        expect(@airport.name).to_not be_nil
      end

      it 're-renders the edit method' do
        put :update, params: {
          id: @airport, airport: attributes_for(:airport, :invalid)
        }
        expect(response).to render_template :edit
      end
    end
  end
end
