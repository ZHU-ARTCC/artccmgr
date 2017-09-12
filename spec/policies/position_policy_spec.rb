require 'rails_helper'

describe PositionPolicy do
  subject { described_class.new(user, position) }

  let(:position) { create(:position) }

  context 'user with position create permission' do
    let(:user){ create(:user, group: create(:group, :perm_position_create)) }

    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions([:index, :destroy, :show]) }
  end

  context 'group with position read permission' do
    let(:user){ create(:user, group: create(:group, :perm_position_read)) }

    it { is_expected.to permit_actions([:index, :show]) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'user with position update permission' do
    let(:user){ create(:user, group: create(:group, :perm_position_update)) }

    it { is_expected.to permit_edit_and_update_actions }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_actions([:index, :destroy, :show]) }
  end

  context 'user with position delete permission' do
    let(:user){ create(:user, group: create(:group, :perm_position_delete)) }

    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions([:index, :show]) }
  end

end
