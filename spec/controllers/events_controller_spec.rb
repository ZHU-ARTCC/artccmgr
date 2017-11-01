require 'rails_helper'
require 'rss'

RSpec.describe EventsController, type: :controller do

  describe 'GET #index' do
    it 'populates an array of @events' do
      event = create(:event)
      get :index
      expect(assigns(:events)).to eq([event])
    end

    it 'responds to RSS' do
      get :index, format: :rss
      expect(response.status).to eq 200
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    context 'when not logged in' do
      it 'does not create Event' do
        expect {
          post :create, params: { event: attributes_for(:event) }
        }.to_not change(Event, :count)
      end
    end

    context 'with valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_event_create))
      end

      it 'creates a new event' do
        expect {
          post :create, params: { event: attributes_for(:event) }
        }.to change(Event, :count).by 1
      end

      it 'redirects to the event #show page' do
        event = attributes_for(:event)
        post :create, params: { event: event }
        event = Event.find_by(name: event[:name])
        expect(response).to redirect_to event_path(event)
      end
    end

    context 'with invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_event_create))
      end

      it 'does not save the new event' do
        expect{
          post :create, params: { event: attributes_for(:event, :invalid) }
        }.to_not change(Event,:count)
      end

      it 're-renders the new template' do
        post :create, params: { event: attributes_for(:event, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @event = create(:event)
    end

    context 'when not logged in' do
      it 'does not delete Event' do
        expect {
          delete :destroy, params: { id: @event }
        }.to_not change(Event, :count)
      end
    end

    context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_event_read, :perm_event_delete))
      end

      it 'deletes the event' do
        expect{
          delete :destroy, params: { id: @event }
        }.to change(Event,:count).by(-1)
      end

      it 'redirects to event#index even the event cannot be deleted' do
        allow_any_instance_of(Event).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: @event }
        expect(response).to redirect_to events_path
      end

      it 'redirects to event#index' do
        delete :destroy, params: { id: @event }
        expect(response).to redirect_to events_path
      end
    end
  end

  describe 'GET #edit' do
    before :each do
      sign_in create(:user, group: create(:group, :perm_event_read, :perm_event_update))
      @event = create(:event)
    end

    it 'assigns the requested event to @event' do
      get :edit, params: { id: @event }
      expect(assigns(:event)).to eq @event
    end

    it 'renders the #edit view' do
      get :edit, params: { id: @event }
      expect(response).to render_template :edit
    end
  end

  describe 'GET #new' do
    it 'redirects to login if no user logged in' do
      get :new
      expect(response).to redirect_to(root_path)
    end

    it 'assigns a new Event object' do
      sign_in create(:user, group: create(:group, :perm_event_create))
      get :new
      expect(assigns(:event)).to be_kind_of Event
    end

    it 'renders the :new view' do
      sign_in create(:user, group: create(:group, :perm_event_create))
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    it 'assigns the requested event to @event' do
      event = create(:event)
      get :show, params: { id: event }
      expect(assigns(:event)).to eq(event)
    end

    it 'renders the #show view' do
      get :show, params: { id: create(:event) }
      expect(response).to render_template :show
    end
  end

  describe 'PUT #update' do
    before :each do
      @event = create(:event)
    end

    context 'when not logged in' do
      it 'does not update Event' do
        put :update, params: { id: @event, event: attributes_for(:event, name: 'Testing') }
        @event.reload
        expect(@event.name).to_not eq 'Testing'
      end
    end

    context 'valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_event_read, :perm_event_update))
      end

      it 'located the requested @event' do
        put :update, params: { id: @event, event: attributes_for(:event) }
        expect(assigns(:event)).to eq @event
      end

      it 'changes @event attributes' do
        put :update, params: {
            id: @event,
            event: attributes_for(:event, name: 'Fly In')
        }
        @event.reload
        expect(@event.name).to eq 'Fly In'
      end

      it 'redirects to the updated event' do
        put :update, params: { id: @event, event: attributes_for(:event) }
        @event.reload
        expect(response).to redirect_to @event
      end
    end

    context 'invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_event_read, :perm_event_update))
      end

      it 'locates the requested @event' do
        put :update, params: { id: @event, event: attributes_for(:event) }
        expect(assigns(:event)).to eq @event
      end

      it 'does not change the @event attributes' do
        put :update, params: { id: @event,
                               event: attributes_for(:event, name: nil)
        }

        @event.reload
        expect(@event.name).to_not be_nil
      end

      it 're-renders the edit method' do
        put :update, params: { id: @event, event: attributes_for(:event, :invalid) }
        expect(response).to render_template :edit
      end
    end
  end

end
