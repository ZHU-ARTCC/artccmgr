# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airport, type: :model do
  it 'has a valid factory' do
    expect(build(:airport)).to be_valid
  end

  let(:airport) { build(:airport) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(airport).to validate_presence_of(:icao) }
    it { expect(airport).to validate_uniqueness_of(:icao).case_insensitive }
    it { expect(airport).to validate_presence_of(:name) }

    # Format validations
    it { expect(airport).to validate_numericality_of(:elevation) }

    it {
      expect(airport).to(
        validate_numericality_of(:latitude)
        .is_greater_than_or_equal_to(-90)
        .is_less_than_or_equal_to(90)
      )
    }

    it {
      expect(airport).to(
        validate_numericality_of(:longitude)
        .is_greater_than_or_equal_to(-180)
        .is_less_than_or_equal_to(180)
      )
    }

    # Inclusion/acceptance of values
    it { expect(airport).to_not allow_value('').for(:icao) }
    it { expect(airport).to_not allow_value('').for(:name) }

    it { expect(airport).to validate_length_of(:icao).is_at_most(4) }
  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
    it { expect(airport).to have_one(:weather) }
    it { expect(airport).to have_many(:charts).dependent(:destroy) }
  end # describe 'ActiveRecord associations'

  describe '#icao=' do
    it 'upcases the ICAO identifier' do
      expect(build(:airport, icao: 'kiws').icao).to eq 'KIWS'
    end
  end

  describe '#name=' do
    it 'titleizes the name' do
      expect(build(:airport, name: 'test airport').name).to eq 'Test Airport'
    end
  end
end
