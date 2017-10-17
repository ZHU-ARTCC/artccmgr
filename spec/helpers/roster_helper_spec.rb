require 'rails_helper'

RSpec.describe RosterHelper, type: :helper do

	describe 'certification status CSS' do

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

	end # describe 'certification status CSS'

end
