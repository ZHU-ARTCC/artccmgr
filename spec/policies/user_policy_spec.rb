require 'rails_helper'

describe UserPolicy do
  subject { described_class.new(test_user, user) }

  let(:user) { create(:user) }

  context 'user with user create permission' do
    let(:test_user){ create(:user, group: create(:group, :perm_user_create)) }

    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions([:index, :destroy, :show]) }
  end

  context 'user with user read permission' do
    let(:test_user){ create(:user, group: create(:group, :perm_user_read)) }

    it { is_expected.to permit_actions([:index, :show]) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'user with user update permission' do
    let(:test_user){ create(:user, group: create(:group, :perm_user_update)) }

    it { is_expected.to permit_edit_and_update_actions }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_actions([:index, :destroy, :show]) }
  end

  context 'user with user delete permission' do
    let(:test_user){ create(:user, group: create(:group, :perm_user_delete)) }

    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions([:index, :show]) }
  end

end
