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

    # Inclusion/acceptance of values
    it { expect(airport).to_not allow_value('').for(:icao) }
    it { expect(airport).to_not allow_value('').for(:name) }

    it { expect(airport).to validate_length_of(:icao).is_at_most(4) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(airport).to have_one(:weather) }

  end # describe 'ActiveRecord associations'

end
