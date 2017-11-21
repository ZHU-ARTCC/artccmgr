# frozen_string_literal: true

require 'rails_helper'

describe CertificationPolicy do
  subject { described_class.new(user, certification) }

  let(:certification) { create(:certification) }

  context 'user with certification create permission' do
    let(:user) do
      create(:user, group: create(:group, :perm_certification_create))
    end

    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'group with certification read permission' do
    let(:user) do
      create(:user, group: create(:group, :perm_certification_read))
    end

    it { is_expected.to permit_actions(%i[index show]) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'user with certification update permission' do
    let(:user) do
      create(:user, group: create(:group, :perm_certification_update))
    end

    it { is_expected.to permit_edit_and_update_actions }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'user with certification delete permission' do
    let(:user) do
      create(:user, group: create(:group, :perm_certification_delete))
    end

    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index show]) }
  end
end
