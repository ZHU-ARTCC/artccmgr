require 'rails_helper'

RSpec.describe Events::SignupsController, type: :controller do

  let(:event){ create(:event) }

  # describe 'GET #index' do
  #   it 'populates the @event' do
  #     event = create(:event)
  #     get :index
  #     expect(assigns(:event)).to eq([event])
  #   end
  #
  #   it 'renders the :index view' do
  #     get :index
  #     expect(response).to render_template :index
  #   end
  # end

  describe 'POST #create' do
    context 'when not logged in' do
      it 'does not create Event Singup' do
        expect {
          post :create, params: { event_id: event.friendly_id, event_signup: build(:event_signup, event: event).attributes }
        }.to_not change(Event::Signup, :count)
      end
    end

    context 'with valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_event_signup_create))
      end

      it 'creates a new event signup' do
        expect {
          post :create, params: { event_id: event.friendly_id, event_signup: build(:event_signup, event: event).attributes }
        }.to change(Event::Signup, :count).by 1
      end

      it 'redirects to the event #show page' do
        event_signup = build(:event_signup, event: event)
        post :create, params: { event_id: event, event_signup: event_signup.attributes }
        expect(response).to redirect_to event_path(event_signup.event)
      end
    end

    context 'with invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_event_signup_create))
      end

      it 'does not save the new event signup' do
        expect{
          post :create, params: { event_id: event, event_signup: build(:event_signup, :invalid, event: event).attributes }
        }.to_not change(Event::Signup,:count)
      end

      it 're-renders the new template' do
        post :create, params: { event_id: event, event_signup: build(:event_signup, :invalid, event: event).attributes }
        expect(response).to render_template :new
      end
    end
  end

  # describe 'DELETE #destroy' do
  #   before :each do
  #     @event = create(:event)
  #   end
  #
  #   context 'when not logged in' do
  #     it 'does not delete Event' do
  #       expect {
  #         delete :destroy, params: { id: @event }
  #       }.to_not change(Event, :count)
  #     end
  #   end
  #
  #   context 'when logged in' do
  #     before :each do
  #       sign_in create(:user, group: create(:group, :perm_event_read, :perm_event_delete))
  #     end
  #
  #     it 'deletes the event' do
  #       expect{
  #         delete :destroy, params: { id: @event }
  #       }.to change(Event,:count).by(-1)
  #     end
  #
  #     it 'redirects to event#index' do
  #       delete :destroy, params: { id: @event }
  #       expect(response).to redirect_to events_path
  #     end
  #   end
  # end

  # describe "GET #edit" do
  #   before :each do
  #     sign_in create(:user, group: create(:group, :perm_event_read, :perm_event_update))
  #     @event = create(:event)
  #   end
  #
  #   it 'assigns the requested event to @event' do
  #     get :edit, params: { id: @event }
  #     expect(assigns(:event)).to eq @event
  #   end
  #
  #   it 'renders the #edit view' do
  #     get :edit, params: { id: @event }
  #     expect(response).to render_template :edit
  #   end
  # end

  describe 'GET #new' do
    it 'redirects to login if no user logged in' do
      get :new, params: { event_id: event.friendly_id }
      expect(response).to redirect_to(user_vatsim_omniauth_authorize_path)
    end

    it 'assigns a new Event::Signup object' do
      sign_in create(:user, group: create(:group, :perm_event_signup_create))
      get :new, params: { event_id: event.friendly_id }
      expect(assigns(:signup)).to be_kind_of Event::Signup
    end

    it 'assigns a new Event::Pilot object' do
      sign_in create(:user, group: create(:group, :perm_event_signup_create))
      get :new, params: { event_id: event.friendly_id }
      expect(assigns(:pilot)).to be_kind_of Event::Pilot
    end

    it 'renders the :new view' do
      sign_in create(:user, group: create(:group, :perm_event_signup_create))
      get :new, params: { event_id: event.friendly_id }
      expect(response).to render_template :new
    end
  end

  # describe 'GET #show' do
  #   it 'assigns the requested event to @event' do
  #     event = create(:event)
  #     get :show, params: { id: event }
  #     expect(assigns(:event)).to eq(event)
  #   end
  #
  #   it 'renders the #show view' do
  #     get :show, params: { id: create(:event) }
  #     expect(response).to render_template :show
  #   end
  # end

  # describe 'PUT #update' do
  #   before :each do
  #     @event = create(:event)
  #   end
  #
  #   context 'when not logged in' do
  #     it 'does not update Event' do
  #       put :update, params: { id: @event, event: attributes_for(:event, name: 'Testing') }
  #       @event.reload
  #       expect(@event.name).to_not eq 'Testing'
  #     end
  #   end
  #
  #   context 'valid attributes' do
  #     before :each do
  #       sign_in create(:user, group: create(:group, :perm_event_read, :perm_event_update))
  #     end
  #
  #     it 'located the requested @event' do
  #       put :update, params: { id: @event, event: attributes_for(:event) }
  #       expect(assigns(:event)).to eq @event
  #     end
  #
  #     it "changes @event's attributes" do
  #       put :update, params: {
  #           id: @event,
  #           event: attributes_for(:event, name: "Fly In")
  #       }
  #       @event.reload
  #       expect(@event.name).to eq 'Fly In'
  #     end
  #
  #     it 'redirects to the updated event' do
  #       put :update, params: { id: @event, event: attributes_for(:event) }
  #       @event.reload
  #       expect(response).to redirect_to @event
  #     end
  #   end
  #
  #   context 'invalid attributes' do
  #     before :each do
  #       sign_in create(:user, group: create(:group, :perm_event_read, :perm_event_update))
  #     end
  #
  #     it 'locates the requested @event' do
  #       put :update, params: { id: @event, event: attributes_for(:event) }
  #       expect(assigns(:event)).to eq @event
  #     end
  #
  #     it "does not change @event's attributes" do
  #       put :update, params: { id: @event,
  #                              event: attributes_for(:event, name: nil)
  #       }
  #
  #       @event.reload
  #       expect(@event.name).to_not be_nil
  #     end
  #
  #     it 're-renders the edit method' do
  #       put :update, params: { id: @event, event: attributes_for(:event, :invalid) }
  #       expect(response).to render_template :edit
  #     end
  #   end
  # end

end
