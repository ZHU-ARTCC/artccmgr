# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityController, type: :controller do
  describe 'GET #index' do
    context 'when not logged in' do
      it 'redirects to the root path' do
        get :index
        expect(response).to redirect_to root_path
      end
    end # context 'when not logged in'

    context 'logged in when not staff' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_user_read, staff: false
        ))
      end

      it 'raises a Pundit NotAuthorized exception' do
        expect { get :index }.to raise_error Pundit::NotAuthorizedError
      end
    end # context 'logged in when not staff'

    context 'logged in when staff' do
      before :each do
        sign_in create(:user, group: create(
          :group, :perm_user_read, staff: true
        ))
      end

      it 'populates an array of @controllers' do
        local_controller = create(:user, :local_controller)
        get :index
        expect(assigns(:controllers)).to eq([local_controller])
      end

      it 'populates an array of @visiting_controllers' do
        visiting_controller = create(:user, :visiting_controller)
        get :index
        expect(assigns(:visiting_controllers)).to eq([visiting_controller])
      end

      it 'accepts a custom start date' do
        start_date = (Time.now.utc - 4.months)

        get :index, params: { start_date: start_date }
        expect(assigns(:report_start)).to eq start_date.utc.beginning_of_month
        expect(assigns(:report_end)).to eq start_date.utc.end_of_month
      end

      it 'renders the :index view' do
        get :index
        expect(response).to render_template :index
      end
    end # context 'when logged in as staff'
  end # describe 'GET #index'
end
