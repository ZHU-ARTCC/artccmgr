require 'rails_helper'

RSpec.describe RosterHelper, type: :helper do

	describe '#cert_status_css' do

		it 'returns full certification color' do
			endorsement = create(:endorsement)
			expect(cert_status_css(endorsement.user, endorsement.certification)).to eq 'bg-success'
		end

		it 'returns solo certification color' do
			endorsement = create(:endorsement, solo: true)
			expect(cert_status_css(endorsement.user, endorsement.certification)).to eq 'bg-warning'
		end

		it 'returns nil when the User does not have the certification' do
			cert = create(:certification)
			user = create(:user)
			expect(cert_status_css(user, cert)).to be_nil
		end

	end # describe '#cert_status_css'

	describe '#initials_options' do
		before :each do
			@user = create(:user, initials: 'AA')
		end

		context 'when no duplicate initials are allowed' do
			before :all do
				Settings.unique_operating_initials = true
			end

			after :all do
				Settings.unique_operating_initials = false
			end

			it 'returns options_for_select and pre-selects the user' do
				assign(:user, @user)
				expect(helper.initials_options).to include('<option selected="selected" disabled="disabled" value="AA">AA</option>')
			end

			it 'returns options_for_select with initials in use disabled' do
				assign(:user, build(:user, initials: nil))
				expect(helper.initials_options).to include('<option disabled="disabled" value="AA">AA</option>')
			end
		end

		context 'when duplicate initials are allowed' do
			before :all do
				Settings.unique_operating_initials = false
			end

			it 'returns options_for_select and pre-selects the user' do
				assign(:user, @user)
				expect(helper.initials_options).to include('<option selected="selected" value="AA">AA</option>')
			end

			it 'returns options_for_selection with no initials disabled' do
				assign(:user, build(:user, initials: nil))
				expect(helper.initials_options).to include('<option value="AA">AA</option>')
			end
		end

	end # describe '#initials_options'

end
