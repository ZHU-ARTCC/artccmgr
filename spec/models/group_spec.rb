# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  it 'has a valid factory' do
    expect(build(:group)).to be_valid
  end

  let(:group) { build(:group) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(group).to validate_presence_of(:name) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(group).to_not allow_value('').for(:name) }

    it {
      expect(group).to validate_uniqueness_of(:name).ignoring_case_sensitivity
    }

    it { expect(group).to validate_numericality_of(:min_controlling_hours) }
  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
    it { expect(group).to have_many(:assignments) }
    it { expect(group).to have_many(:users) }
    it { expect(group).to have_many(:permissions) }
  end # describe 'ActiveRecord associations'

  describe '#name=' do
    it 'titleizes the name' do
      expect(build(:group, name: 'test').name).to eq 'Test'
    end
  end

  describe 'that have members of this ARTCC' do
    # Controllers can be members of the ARTCC
    it {
      expect(
        build(:group, atc: true, visiting: false)
      ).to be_valid
    }
  end

  describe 'that have visiting controllers' do
    # Controllers can be visiting controllers
    it {
      expect(
        build(:group, atc: true, visiting: true)
      ).to be_valid
    }
  end

  describe '#destroy' do
    it 'does not allow deletion if users are still a member' do
      group = create(:user).group
      expect { group.destroy }.to_not change(Group, :count)
    end
  end # describe '#destroy'

  describe 'built in named' do
    context 'Air Traffic Manager' do
      before :each do
        @group = Group.find_by(name: 'Air Traffic Manager')
      end

      it 'should not be deleted' do
        expect { @group.destroy }.to_not change(Group, :count)
      end

      it 'should not be valid if the name changes' do
        @group.name = 'Test Group'
        expect(@group).to_not be_valid
      end
    end # context 'Air Traffic Manager'

    context 'Deputy Air Traffic Manager' do
      before :each do
        @group = Group.find_by(name: 'Deputy Air Traffic Manager')
      end

      it 'should not be deleted' do
        expect { @group.destroy }.to_not change(Group, :count)
      end

      it 'should not be valid if the name changes' do
        @group.name = 'Test Group'
        expect(@group).to_not be_valid
      end
    end # context 'Deputy Air Traffic Manager'

    context 'Training Administrator' do
      before :each do
        @group = Group.find_by(name: 'Training Administrator')
      end

      it 'should not be deleted' do
        expect { @group.destroy }.to_not change(Group, :count)
      end

      it 'should not be valid if the name changes' do
        @group.name = 'Test Group'
        expect(@group).to_not be_valid
      end
    end # context 'Training Administrator'

    context 'Events Coordinator' do
      before :each do
        @group = Group.find_by(name: 'Events Coordinator')
      end

      it 'should not be deleted' do
        expect { @group.destroy }.to_not change(Group, :count)
      end

      it 'should not be valid if the name changes' do
        @group.name = 'Test Group'
        expect(@group).to_not be_valid
      end
    end # context 'Events Coordinator'

    context 'Facility Engineer' do
      before :each do
        @group = Group.find_by(name: 'Facility Engineer')
      end

      it 'should not be deleted' do
        expect { @group.destroy }.to_not change(Group, :count)
      end

      it 'should not be valid if the name changes' do
        @group.name = 'Test Group'
        expect(@group).to_not be_valid
      end
    end # context 'Facility Engineer'

    context 'Webmaster' do
      before :each do
        @group = Group.find_by(name: 'Webmaster')
      end

      it 'should not be deleted' do
        expect { @group.destroy }.to_not change(Group, :count)
      end

      it 'should not be valid if the name changes' do
        @group.name = 'Test Group'
        expect(@group).to_not be_valid
      end
    end

    context 'Guest' do
      before :each do
        @group = Group.find_by(name: 'Guest')
      end

      it 'should not be deleted' do
        expect { @group.destroy }.to_not change(Group, :count)
      end

      it 'should not be valid if the name changes' do
        @group.name = 'Test Group'
        expect(@group).to_not be_valid
      end
    end # context 'Guest'

    context 'Public' do
      before :each do
        @group = Group.find_by(name: 'Public')
      end

      it 'should not be deleted' do
        expect { @group.destroy }.to_not change(Group, :count)
      end

      it 'should not be valid if the name changes' do
        @group.name = 'Test Group'
        expect(@group).to_not be_valid
      end
    end # context 'Public'
  end # describe 'builtin group'
end
