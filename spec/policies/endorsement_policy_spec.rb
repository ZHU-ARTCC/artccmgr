# frozen_string_literal: true

require 'rails_helper'

describe EndorsementPolicy do
  subject { described_class.new(user, endorsement) }

  let(:endorsement) { create(:endorsement) }

  context 'user with endorsement create permission' do
    let(:user) do
      create(:user, group: create(:group, :perm_endorsement_create))
    end

    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'group with endorsement read permission' do
    let(:user) do
      create(:user, group: create(:group, :perm_endorsement_read))
    end

    it { is_expected.to permit_actions(%i[index show]) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'user with endorsement update permission' do
    let(:user) do
      create(:user, group: create(:group, :perm_endorsement_update))
    end

    it { is_expected.to permit_edit_and_update_actions }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'user with endorsement delete permission' do
    let(:user) do
      create(:user, group: create(:group, :perm_endorsement_delete))
    end

    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index show]) }
  end
end
