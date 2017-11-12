require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do

	describe 'GET #show' do
		context 'when not logged in' do
			it 'redirects to the root page' do
				get :show
				expect(response).to redirect_to root_path
			end
		end

		context 'when logged in' do
			before :each do
				@user = create(:user)
				sign_in @user
			end

			it 'sets assigns the current user' do
				get :show
				expect(assigns(:user)).to eq @user
			end

			it 'renders the show template' do
				get :show
				expect(response).to render_template :show
			end
		end
	end # describe 'GET #show'

end
