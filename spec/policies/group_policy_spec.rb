# frozen_string_literal: true

require 'rails_helper'

describe GroupPolicy do
  subject { described_class.new(test_user, user) }

  let(:user) { create(:user) }

  context 'user with group create permission' do
    let(:test_user) { create(:user, group: create(:group, :perm_group_create)) }

    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'user with group read permission' do
    let(:test_user) { create(:user, group: create(:group, :perm_group_read)) }

    it { is_expected.to permit_actions(%i[index show]) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'user with group update permission' do
    let(:test_user) { create(:user, group: create(:group, :perm_group_update)) }

    it { is_expected.to permit_edit_and_update_actions }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'user with group delete permission' do
    let(:test_user) { create(:user, group: create(:group, :perm_group_delete)) }

    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index show]) }
  end
end
