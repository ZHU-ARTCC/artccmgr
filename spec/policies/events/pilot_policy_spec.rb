require 'rails_helper'

describe Event::PilotPolicy do
  subject { described_class.new(user, event_pilot) }

  let(:event_pilot) { create(:event_pilot) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Event::Pilot.all).resolve
  end

  context 'user with event pilot signup create permission' do
    let(:user){ create(:user, group: create(:group, :perm_event_pilot_signup_create)) }

    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions([:index, :destroy, :show]) }
  end

  context 'group with event signup read permission' do
    let(:user){ create(:user, group: create(:group, :perm_event_pilot_signup_read)) }

    it { is_expected.to permit_actions([:index, :show]) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'user with event signup update permission' do
    let(:user){ create(:user, group: create(:group, :perm_event_pilot_signup_update)) }

    it { is_expected.to permit_edit_and_update_actions }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_actions([:index, :destroy, :show]) }
  end

  context 'user with event signup delete permission' do
    let(:user){ create(:user, group: create(:group, :perm_event_pilot_signup_delete)) }

    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions([:index, :show]) }
  end

end
