require 'rails_helper'

RSpec.describe Weather, type: :model do

  it 'has a valid factory' do
    expect(build(:weather)).to be_valid
  end

  let(:weather) { build(:weather) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(weather).to validate_presence_of(:rules) }
    it { expect(weather).to validate_presence_of(:wind) }
    it { expect(weather).to validate_presence_of(:altimeter) }
    it { expect(weather).to validate_presence_of(:metar) }

    # Inclusion/acceptance of values
    it { expect(weather).to_not allow_value('').for(:rules) }
    it { expect(weather).to_not allow_value('').for(:wind) }
    it { expect(weather).to_not allow_value('').for(:altimeter) }
    it { expect(weather).to_not allow_value('').for(:metar) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do

    it { expect(weather).to belong_to(:airport) }

  end # describe 'ActiveRecord associations'

  describe 'delegate methods' do

    it { expect(weather).to delegate_method(:icao).to(:airport) }

  end # describe 'ActiveRecord associations'

end
