require 'rails_helper'

RSpec.describe RosterController, type: :controller do

  describe 'GET #index' do
    it 'populates an array of @controllers' do
      artcc_controller = create(:user, :artcc_controller)
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

end
