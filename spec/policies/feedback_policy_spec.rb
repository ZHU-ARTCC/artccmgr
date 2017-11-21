# frozen_string_literal: true

require 'rails_helper'

describe FeedbackPolicy do
  subject { described_class.new(user, feedback) }

  let(:feedback) { create(:feedback) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Feedback.all).resolve
  end

  context 'user with feedback create permission' do
    let(:user) { create(:user, group: create(:group, :perm_feedback_create)) }

    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'group with feedback read permission' do
    let(:user) { create(:user, group: create(:group, :perm_feedback_read)) }

    context 'accessing published feedback' do
      let(:feedback) { create(:feedback, published: true) }

      it 'includes feedback in resolved scope' do
        expect(resolved_scope).to include(feedback)
      end
    end

    context 'accessing unpublished feedback' do
      let(:feedback) { create(:feedback, published: false) }

      it 'includes feedback from resolved scope' do
        expect(resolved_scope).to include(feedback)
      end
    end

    it { is_expected.to permit_actions(%i[index show]) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'user with feedback read published permission' do
    let(:user) do
      create(:user, group: create(:group, :perm_feedback_read_published))
    end

    context 'accessing published feedback' do
      let(:feedback) { create(:feedback, published: true) }

      it 'includes feedback in resolved scope' do
        expect(resolved_scope).to include(feedback)
      end
    end

    context 'accessing unpublished feedback' do
      let(:feedback) { create(:feedback, published: false) }

      it 'excludes feedback from resolved scope' do
        expect(resolved_scope).not_to include(feedback)
      end
    end

    it { is_expected.to permit_actions(%i[index show]) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'user with feedback update permission' do
    let(:user) { create(:user, group: create(:group, :perm_feedback_update)) }

    it { is_expected.to permit_edit_and_update_actions }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end

  context 'user with feedback delete permission' do
    let(:user) { create(:user, group: create(:group, :perm_feedback_delete)) }

    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index show]) }
  end
end
