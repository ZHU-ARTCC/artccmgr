# frozen_string_literal: true

require 'rails_helper'

describe ApplicationPolicy do
  subject { described_class.new(user, ApplicationRecord) }

  let(:user) { create(:user) }

  context 'defaults' do
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(%i[index destroy show]) }
  end
end
