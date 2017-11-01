require 'rails_helper'

RSpec.describe CertificationsController, type: :controller do

	describe 'GET #index' do
		context 'when not logged in' do
			it 'redirects to the root page' do
				expect(get(:index)).to redirect_to root_path
			end
		end

		context 'when logged in' do
			before :each do
				sign_in create(:user, group: create(:group, :perm_certification_read))
			end

			it 'populates an array of @certifications' do
				certification = create(:certification)
				get :index
				expect(assigns(:certifications)).to eq([certification])
			end

			it 'renders the :index view' do
				get :index
				expect(response).to render_template :index
			end
		end
	end

	describe 'POST #create' do
		context 'when not logged in' do
			it 'does not create the Certification' do
				expect {
					post :create, params: { certification: attributes_for(:certification) }
				}.to_not change(Certification, :count)
			end
		end

		context 'with valid attributes' do
			before :each do
				sign_in create(:user, group: create(:group, :perm_certification_create))
			end

			it 'creates a new certification' do
				expect {
					post :create, params: { certification: attributes_for(:certification) }
				}.to change(Certification, :count).by 1
			end

			it 'redirects to the certification #index' do
				post :create, params: { certification: attributes_for(:certification) }
				expect(response).to redirect_to certifications_path
			end
		end

		context 'with invalid attributes' do
			before :each do
				sign_in create(:user, group: create(:group, :perm_certification_create))
			end

			it 'does not save the new certification' do
				expect{
					post :create, params: { certification: attributes_for(:certification, :invalid) }
				}.to_not change(Certification,:count)
			end

			it 're-renders the new template' do
				post :create, params: { certification: attributes_for(:certification, :invalid) }
				expect(response).to render_template :new
			end
		end
	end

	describe 'DELETE #destroy' do
		before :each do
			@certification = create(:certification)
		end

		context 'when not logged in' do
			it 'does not delete the certification' do
				expect {
					delete :destroy, params: { id: @certification }
				}.to_not change(Certification, :count)
			end
		end

		context 'when logged in' do
			before :each do
				sign_in create(:user, group: create(:group, :perm_certification_read, :perm_certification_delete))
			end

			it 'deletes the certification' do
				expect{
					delete :destroy, params: { id: @certification }
				}.to change(Certification, :count).by(-1)
			end

			it 'redirects to certification#index' do
				delete :destroy, params: { id: @certification }
				expect(response).to redirect_to certifications_path
      end

			it 'redirects to certification#show if the certification cannot be deleted' do
				allow_any_instance_of(Certification).to receive(:destroy).and_return(false)
				delete :destroy, params: { id: @certification }
				expect(response).to redirect_to certifications_path(@certification)
			end
		end
	end

	describe 'GET #edit' do
		before :each do
			sign_in create(:user, group: create(:group, :perm_certification_read, :perm_certification_update))
			@certification = create(:certification)
		end

		it 'assigns the requested certification to @certification' do
			get :edit, params: { id: @certification }
			expect(assigns(:certification)).to eq @certification
		end

		it 'renders the #edit view' do
			get :edit, params: { id: @certification }
			expect(response).to render_template :edit
		end
	end

	describe 'GET #new' do
		before :each do
			sign_in create(:user, group: create(:group, :perm_certification_create))
		end

		it 'assigns the a new certification to @certification' do
			get :new
			expect(assigns(:certification)).to be_kind_of Certification
		end

		it 'renders the #new view' do
			get :new
			expect(response).to render_template :new
		end
	end

	describe 'GET #show' do
		context 'when not logged in' do
			it 'redirects to the root page' do
				expect(get(:index)).to redirect_to root_path
			end
		end

		context 'when logged in' do
			before :each do
				sign_in create(:user, group: create(:group, :perm_certification_read))
			end

			it 'assigns the requested certification to @certification' do
				certification = create(:certification)
				get :show, params: { id: certification }
				expect(assigns(:certification)).to eq certification
			end

			it 'renders the #show view' do
				get :show, params: { id: create(:certification) }
				expect(response).to render_template :show
			end
		end
	end

	describe 'PUT #update' do
		before :each do
			@certification = create(:certification)
		end

		context 'when not logged in' do
			it 'does not update Certification' do
				put :update, params: { id: @certification, certification: attributes_for(:certification, name: 'Testing') }
				@certification.reload
				expect(@certification.name).to_not eq 'Testing'
			end
		end

		context 'valid attributes' do
			before :each do
				sign_in create(:user, group: create(:group, :perm_certification_read, :perm_certification_update))
			end

			it 'located the requested @certification' do
				put :update, params: { id: @certification, certification: attributes_for(:certification) }
				expect(assigns(:certification)).to eq @certification
			end

			it 'changes @certification\'s attributes' do
				put :update, params: {
						id: @certification,
						certification: attributes_for(:certification, name: 'Houston Center')
				}
				@certification.reload
				expect(@certification.name).to eq 'Houston Center'
			end

			it 'redirects to the updated certification' do
				put :update, params: { id: @certification, certification: attributes_for(:certification) }
				expect(response).to redirect_to certifications_path
			end
		end

		context 'invalid attributes' do
			before :each do
				sign_in create(:user, group: create(:group, :perm_certification_read, :perm_certification_update))
			end

			it 'locates the requested @certification' do
				put :update, params: { id: @certification, certification: attributes_for(:certification, :invalid) }
				expect(assigns(:certification)).to eq @certification
			end

			it "does not change @certification's attributes" do
				put :update, params: { id: @certification,
				                       certification: attributes_for(:certification, name: nil)
				}

				@certification.reload
				expect(@certification.name).to_not be_nil
			end

			it 're-renders the edit method' do
				put :update, params: { id: @certification, certification: attributes_for(:certification, :invalid) }
				expect(response).to render_template :edit
			end
		end
	end

end
