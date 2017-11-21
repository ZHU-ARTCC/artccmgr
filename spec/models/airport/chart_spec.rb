# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airport::Chart, type: :model do
  it 'has a valid factory' do
    expect(build(:airport_chart)).to be_valid
  end

  let(:chart) { build(:airport_chart) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(chart).to validate_presence_of(:category) }
    it { expect(chart).to validate_presence_of(:name) }
    it { expect(chart).to validate_presence_of(:url) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(chart).to_not allow_value('').for(:category) }
    it { expect(chart).to_not allow_value('').for(:name) }
    it { expect(chart).to_not allow_value('').for(:url) }
  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
    it { expect(chart).to belong_to(:airport) }
  end # describe 'ActiveRecord associations'
end
