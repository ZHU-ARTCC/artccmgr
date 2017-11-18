require 'rails_helper'

describe GpgKeyPolicy do

  describe 'permits users to manage their own keys' do
    subject { described_class.new(user, key) }
    let(:user)  { create(:user) }
    let(:key)   { create(:gpg_key, user: user) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:destroy) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
  end # describe 'permits users to manage their own devices'

  describe 'forbids other users from manipulating others users keys' do
    subject { described_class.new(user, key) }
    let(:user)  { create(:user) }
    let(:key)   { create(:gpg_key) }

    it { is_expected.to forbid_actions([:index, :create, :destroy, :edit, :new, :show, :update]) }
  end

end