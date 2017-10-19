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
    it { expect(rating).to validate_numericality_of(:number).is_greater_than_or_equal_to(0) }

    # Inclusion/acceptance of values
    it { expect(rating).to_not allow_value('').for(:short_name) }
    it { expect(rating).to_not allow_value('').for(:long_name) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(rating).to have_many(:users) }

  end # describe 'ActiveRecord associations'

end
