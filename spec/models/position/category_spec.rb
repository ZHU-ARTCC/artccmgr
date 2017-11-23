# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Position::Category, type: :model do
  it 'has a valid factory' do
    expect(build(:position_category)).to be_valid
  end

  let(:category) { build(:position_category) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(category).to validate_presence_of(:name) }
    it { expect(category).to validate_presence_of(:short) }

    # Format validations
    it { expect(category).to validate_length_of(:short).is_at_most(7) }

    # Inclusion/acceptance of values
    it { expect(category).to_not allow_value('').for(:name) }
    it { expect(category).to_not allow_value('').for(:short) }
  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
    it { expect(category).to have_many(:positions) }
  end # describe 'ActiveRecord associations'

  describe '#can_solo?' do
    it 'specifies whether position category can have solo certifications' do
      expect(category.can_solo?).to be_in [true, false]
    end
  end
end
