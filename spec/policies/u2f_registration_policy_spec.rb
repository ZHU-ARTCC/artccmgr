require 'rails_helper'

describe U2fRegistrationPolicy do

	describe 'permits users to manage their own devices' do
		subject { described_class.new(user, u2f) }
		let(:user)  { create(:user) }
		let(:u2f)   { create(:u2f_registration, user: user) }

		it { is_expected.to permit_action(:index) }
		it { is_expected.to permit_action(:create) }
		it { is_expected.to permit_action(:destroy) }
		it { is_expected.to permit_action(:edit) }
		it { is_expected.to permit_action(:new) }
		it { is_expected.to permit_action(:show) }
		it { is_expected.to permit_action(:update) }
	end # describe 'permits users to manage their own devices'

	describe 'forbids other users from manipulating others users devices' do
		subject { described_class.new(user, u2f) }
		let(:user)  { create(:user) }
		let(:u2f)   { create(:u2f_registration) }

		it { is_expected.to forbid_actions([:index, :create, :destroy, :edit, :new, :show, :update]) }
	end

end
