require 'rails_helper'

describe CertificationPolicy do
	subject { described_class.new(user, certification) }

	let(:certification) { create(:certification) }

	context 'user with certification create permission' do
		let(:user){ create(:user, group: create(:group, :perm_certification_create)) }

		it { is_expected.to permit_new_and_create_actions }

		it { is_expected.to forbid_edit_and_update_actions }
		it { is_expected.to forbid_actions([:index, :destroy, :show]) }
	end

	context 'group with certification read permission' do
		let(:user){ create(:user, group: create(:group, :perm_certification_read)) }

		it { is_expected.to permit_actions([:index, :show]) }

		it { is_expected.to forbid_new_and_create_actions }
		it { is_expected.to forbid_edit_and_update_actions }
		it { is_expected.to forbid_action(:destroy) }
	end

	context 'user with certification update permission' do
		let(:user){ create(:user, group: create(:group, :perm_certification_update)) }

		it { is_expected.to permit_edit_and_update_actions }

		it { is_expected.to forbid_new_and_create_actions }
		it { is_expected.to forbid_actions([:index, :destroy, :show]) }
	end

	context 'user with certification delete permission' do
		let(:user){ create(:user, group: create(:group, :perm_certification_delete)) }

		it { is_expected.to permit_action(:destroy) }

		it { is_expected.to forbid_new_and_create_actions }
		it { is_expected.to forbid_edit_and_update_actions }
		it { is_expected.to forbid_actions([:index, :show]) }
	end

end
