require 'rails_helper'

describe EndorsementPolicy do
	subject { described_class.new(user, endorsement) }

	let(:endorsement) { create(:endorsement) }

	context 'user with endorsement create permission' do
		let(:user){ create(:user, group: create(:group, :perm_endorsement_create)) }

		it { is_expected.to permit_new_and_create_actions }

		it { is_expected.to forbid_edit_and_update_actions }
		it { is_expected.to forbid_actions([:index, :destroy, :show]) }
	end

	context 'group with endorsement read permission' do
		let(:user){ create(:user, group: create(:group, :perm_endorsement_read)) }

		it { is_expected.to permit_actions([:index, :show]) }

		it { is_expected.to forbid_new_and_create_actions }
		it { is_expected.to forbid_edit_and_update_actions }
		it { is_expected.to forbid_action(:destroy) }
	end

	context 'user with endorsement update permission' do
		let(:user){ create(:user, group: create(:group, :perm_endorsement_update)) }

		it { is_expected.to permit_edit_and_update_actions }

		it { is_expected.to forbid_new_and_create_actions }
		it { is_expected.to forbid_actions([:index, :destroy, :show]) }
	end

	context 'user with endorsement delete permission' do
		let(:user){ create(:user, group: create(:group, :perm_endorsement_delete)) }

		it { is_expected.to permit_action(:destroy) }

		it { is_expected.to forbid_new_and_create_actions }
		it { is_expected.to forbid_edit_and_update_actions }
		it { is_expected.to forbid_actions([:index, :show]) }
	end

end
