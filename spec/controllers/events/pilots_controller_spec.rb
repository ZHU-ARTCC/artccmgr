require 'rails_helper'

RSpec.describe Events::PilotsController, type: :controller do

  let(:event){ create(:event) }

  describe 'POST #create' do
    context 'when not logged in' do
      it 'does not create Pilot Signup' do
        expect {
          post :create, params: { event_id: event.friendly_id, event_pilot: build(:event_pilot, event: event).attributes }
        }.to_not change(Event::Pilot, :count)
      end
    end

    context 'with valid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_event_pilot_signup_create))
      end

      it 'creates a new event pilot' do
        expect {
          post :create, params: { event_id: event.friendly_id, event_pilot: build(:event_pilot, event: event).attributes }
        }.to change(Event::Pilot, :count).by 1
      end

      it 'redirects to the event #show page' do
        event_pilot = build(:event_pilot, event: event)
        post :create, params: { event_id: event, event_pilot: event_pilot.attributes }
        expect(response).to redirect_to event_path(event_pilot.event)
      end
    end

    context 'with invalid attributes' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_event_pilot_signup_create))
      end

      it 'does not save the new event pilot' do
        expect{
          post :create, params: { event_id: event, event_pilot: build(:event_pilot, :invalid, event: event).attributes }
        }.to_not change(Event::Pilot,:count)
      end

      it 're-renders the new template' do
        post :create, params: { event_id: event, event_pilot: build(:event_pilot, :invalid, event: event).attributes }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @event_pilot = create(:event_pilot)
    end

    context 'when not logged in' do
      it 'does not delete Event Pilot' do
        expect {
          delete :destroy, params: { id: @event_pilot, event_id: @event_pilot.event.id }
        }.to_not change(Event::Pilot, :count)
      end
    end

    context 'when logged in' do
      before :each do
        sign_in create(:user, group: create(:group, :perm_event_pilot_signup_read, :perm_event_pilot_signup_delete))
      end

      it 'deletes the event' do
        expect{
          delete :destroy, params: { id: @event_pilot, event_id: @event_pilot.event.id }
        }.to change(Event::Pilot,:count).by(-1)
      end

      it 'redirects to event#index' do
        delete :destroy, params: { id: @event_pilot, event_id: @event_pilot.event.id }
        expect(response).to redirect_to event_path(@event_pilot.event)
      end

      it 'redirects to the events#index path if the Event Pilot cannot be deleted' do
        allow_any_instance_of(Event::Pilot).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: @event_pilot, event_id: @event_pilot.event.id }
        expect(response).to redirect_to event_path(@event_pilot.event)
      end
    end
  end

end
