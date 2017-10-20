require 'rails_helper'

describe AirportPolicy do
  subject { described_class.new(user, airport) }

  let(:airport) { create(:airport) }

  context 'user with airport create permission' do
    let(:user){ create(:user, group: create(:group, :perm_airport_create)) }

    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions([:index, :destroy, :show]) }
  end

  context 'group with airport read permission' do
    let(:user){ create(:user, group: create(:group, :perm_airport_read)) }

    it { is_expected.to permit_actions([:index, :show]) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'user with airport update permission' do
    let(:user){ create(:user, group: create(:group, :perm_airport_update)) }

    it { is_expected.to permit_edit_and_update_actions }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_actions([:index, :destroy, :show]) }
  end

  context 'user with airport delete permission' do
    let(:user){ create(:user, group: create(:group, :perm_airport_delete)) }

    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions([:index, :show]) }
  end

end
