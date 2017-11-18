require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do

	before :all do
		OmniAuth.config.test_mode = true
	end

	describe '#failure' do
		before :each do
			OmniAuth.config.on_failure = Proc.new { |env|
				OmniAuth::FailureEndpoint.new(env).redirect_to_failure
			}

			OmniAuth.config.mock_auth[:vatsim] = :invalid_credentials

			request.env['devise.mapping'] = Devise.mappings[:user]
			request.env['omniauth.auth']  = OmniAuth.config.mock_auth[:vatsim]
		end

		it 'does not sign in a user' do
			get :vatsim
			expect(warden.authenticated?(:user)).to eq false
		end

		it 'sets a flash message' do
      get :vatsim
			expect(controller).to set_flash[:notice]
		end

		it 'redirects to the root_path' do
			get :vatsim
			expect(response).to redirect_to root_path
		end

	end # describe '#failure'

	describe '#vatsim' do
		before :each do
			OmniAuth.config.mock_auth[:vatsim] = OmniAuth::AuthHash.new({
        provider: 'vatsim',
        uid: 9999999,
        info: {
          id:         9999999,
          name_first: 'John',
          name_last:  'Doe',
          rating: {
              id:     '5',
              short:  'C1',
              long:   'Controller 1',
              GRP:    'Controller'
          },
          email:      'noreply@example.com',
          experience: 'N',
          reg_date:   Time.now,
          country:      { code: 'US', name: 'United States'  },
          region:       { code: 'NA', name: 'North America'  },
          division:     { code: 'NA', name: 'North America'  },
          subdivision:  { code: 'USA', name: 'United States' }
        }
      })

      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth']  = OmniAuth.config.mock_auth[:vatsim]
		end

		context 'with new user' do
			it 'should create a new user object' do
				expect{get :vatsim}.to change{User.count}.by(1)
			end

			it 'should update the new user object with VATSIM SSO data' do
				get :vatsim
				user = User.find_by(cid: 9999999)
				expect(user.name_first).to  eq 'John'
				expect(user.name_last).to   eq 'Doe'
				expect(user.email).to       eq 'noreply@example.com'
				expect(user.reg_date).to    be <= Time.now
				expect(user.group).to       eq Group.find_by(name: 'Guest')
				expect(user.initials).to    be_nil
				expect(user.rating).to      eq Rating.find_by(number: 5)
			end

		end # context 'with new user'

		context 'with existing user' do
			before :each do
				User.destroy_all
				@user = create(:user, cid: 9999999)
			end

			it 'should find an existing user object' do
				get :vatsim
				expect(assigns(:user)).to eq(@user)
			end

			it 'should reconcile any changes trusting the VATSIM SSO data' do
				get :vatsim
				@user.reload
				expect(@user.name_first).to  eq 'John'
				expect(@user.name_last).to   eq 'Doe'
				expect(@user.email).to       eq 'noreply@example.com'
				expect(@user.reg_date).to    be <= Time.now
				expect(@user.initials).to    be_nil
				expect(@user.rating).to      eq Rating.find_by(number: 5)
			end

			it 'should not change the users group' do
				group = @user.group
				get :vatsim
				@user.reload
				expect(@user.group).to eq group
			end

			context 'with 2FA' do
				before :each do
					User.destroy_all
					@user = create(:user, :two_factor_via_otp, :two_factor_via_u2f, cid: 9999999)
				end

				it 'prompts the user for the second factor' do
					get :vatsim
					expect(response).to render_template 'two_factor', 'sessions/two_factor'
				end
			end # context 'with 2FA user'
		end # context 'with existing user'

		it 'should sign in the user' do
			get :vatsim
			expect(warden.authenticated?(:user)).to eq true
		end

		it 'should redirect to the website' do
			get :vatsim
			expect(response).to redirect_to root_path
    end
  end # describe '#vatsim'

  describe '#authenticate_with_two_factor' do
    before do
			@request.env["devise.mapping"] = Devise.mappings[:user]
    end

    context 'via OTP' do
      before do
      	@user = create(:user, :two_factor_via_otp)
      	session[:otp_user_id] = @user.id
      end

      context 'valid attempt' do
        before do
          allow_any_instance_of(User).to receive(:validate_and_consume_otp!).and_return(true)
					post :authenticate_with_two_factor, params: { otp_attempt: '123456' }
        end

        it 'deletes the otp_user_id from the session' do
          expect(session[:otp_user_id]).to be nil
        end

        it 'signs in the user' do
          expect(controller.current_user).to eq @user
        end
      end

      context 'using backup code' do
				before do
					allow_any_instance_of(User).to receive(:invalidate_otp_backup_code!).and_return(true)
					post :authenticate_with_two_factor, params: { otp_attempt: '123456' }
        end

        it 'signs in the user' do
          expect(controller.current_user).to eq @user
        end
      end

      context 'invalid attempt' do
        before do
					allow_any_instance_of(User).to receive(:validate_and_consume_otp!).and_return(false)
					post :authenticate_with_two_factor, params: { otp_attempt: '123456' }
        end

        it 'prompts again for the second factor' do
					expect(response).to render_template 'two_factor', 'sessions/two_factor'
        end
      end
    end

    context 'via U2F' do
      before do
        @user = create(:user, :two_factor_via_u2f)
        session[:otp_user_id] = @user.id
        session[:challenge]   = 'abcdef'
      end

      context 'valid attempt' do
        before do
					allow(U2fRegistration).to receive(:authenticate).and_return(true)
          post :authenticate_with_two_factor, params: { user: { device_response: '1234'} }
        end

        it 'deletes the otp_user_id from the session' do
          expect(session[:otp_user_id]).to be nil
        end

        it 'deletes the challenge from the session' do
          expect(session[:challenge]).to be nil
        end
      end

      context 'invalid attempt' do
        before do
					allow(U2fRegistration).to receive(:authenticate).and_return(false)
					post :authenticate_with_two_factor, params: { user: { device_response: '1234'} }
        end

        it 'prompts again for the second factor' do
					expect(response).to render_template 'two_factor', 'sessions/two_factor'
        end
      end

      context 'empty device response' do
        before do
					post :authenticate_with_two_factor, params: { user: { device_response: nil } }
        end

				it 're-prompts the user for the second factor' do
					expect(response).to render_template 'two_factor', 'sessions/two_factor'
				end
      end
    end
  end # describe '#authenticate_with_two_factor'

end
