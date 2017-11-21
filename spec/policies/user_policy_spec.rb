# frozen_string_literal: true

require 'rails_helper'

describe UserPolicy do
  subject { described_class.new(test_user, user) }

  let(:user) { create(:user) }

  context 'user with user create permission' do
    let(:test_user) { create(:user, group: create(:group, :perm_user_create)) }

    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'user with user read permission' do
    let(:test_user) { create(:user, group: create(:group, :perm_user_read)) }

    it { is_expected.to permit_actions(%i[index show]) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'user with user update permission' do
    let(:test_user) { create(:user, group: create(:group, :perm_user_update)) }

    it { is_expected.to permit_edit_and_update_actions }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'user with user delete permission' do
    let(:test_user) { create(:user, group: create(:group, :perm_user_delete)) }

    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index show]) }
  end

  describe 'allows users own profile' do
    subject { described_class.new(user, user_obj) }
    let(:user_obj) { create(:user) }

    context 'permit show action' do
      let(:user) { user_obj }
      it { is_expected.to permit_action(:show) }
    end

    context 'forbid actions index, create, destroy' do
      let(:user) { user_obj }
      it { is_expected.to forbid_actions(%i[index create destroy edit]) }
    end
  end # describe 'users own profiles'
end
