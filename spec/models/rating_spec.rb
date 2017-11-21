# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating, type: :model do
  it 'has a valid factory' do
    expect(build(:rating)).to be_valid
  end

  let(:rating) { build(:rating) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(rating).to validate_presence_of(:number) }
    it { expect(rating).to validate_presence_of(:short_name) }
    it { expect(rating).to validate_presence_of(:long_name) }

    # Format validations
    it {
      expect(rating).to(
        validate_numericality_of(:number)
        .is_greater_than_or_equal_to(0)
      )
    }

    # Inclusion/acceptance of values
    it { expect(rating).to_not allow_value('').for(:short_name) }
    it { expect(rating).to_not allow_value('').for(:long_name) }
  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
    it { expect(rating).to have_many(:users) }
  end # describe 'ActiveRecord associations'

  describe '#to_i' do
    before :each do
      @rating = build(:rating, number: 10)
    end

    it { expect(@rating.to_i).to be_kind_of Integer }
    it { expect(@rating.to_i).to eq 10 }
  end # describe '#to_i'

  describe '#to_s' do
    before :each do
      @rating = build(:rating, short_name: 'T1', long_name: 'Test Rating 1')
    end

    it { expect(@rating.to_s).to be_kind_of String }
    it { expect(@rating.to_s).to eq 'Test Rating 1 (T1)' }
  end # describe '#to_s'
end
