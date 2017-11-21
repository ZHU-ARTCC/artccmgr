# frozen_string_literal: true

require 'rails_helper'

describe EventPolicy do
  subject { described_class.new(user, event) }

  let(:event) { create(:event) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Event.all).resolve
  end

  context 'user with event create permission' do
    let(:user) { create(:user, group: create(:group, :perm_event_create)) }

    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'group with event read permission' do
    let(:user) { create(:user, group: create(:group, :perm_event_read)) }

    it { is_expected.to permit_actions(%i[index show]) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'user with event update permission' do
    let(:user) { create(:user, group: create(:group, :perm_event_update)) }

    it { is_expected.to permit_edit_and_update_actions }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'user with event delete permission' do
    let(:user) { create(:user, group: create(:group, :perm_event_delete)) }

    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index show]) }
  end
end
