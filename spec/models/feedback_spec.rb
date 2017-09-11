require 'rails_helper'

RSpec.describe Feedback, type: :model do

  it 'has a valid factory' do
    expect(build(:feedback)).to be_valid
  end

  let(:feedback) { build(:feedback) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(feedback).to validate_presence_of(:cid) }
    it { expect(feedback).to validate_presence_of(:name) }
    it { expect(feedback).to validate_presence_of(:email) }
    it { expect(feedback).to validate_presence_of(:callsign) }
    it { expect(feedback).to validate_presence_of(:controller) }
    it { expect(feedback).to validate_presence_of(:position) }
    it { expect(feedback).to validate_presence_of(:service_level) }
    it { expect(feedback).to validate_presence_of(:comments) }

    # Format validations
    it { expect(feedback).to validate_numericality_of(:service_level).is_greater_than(0).is_less_than_or_equal_to(5) }

    # Inclusion/acceptance of values
    it { expect(feedback).to_not allow_value('').for(:cid) }
    it { expect(feedback).to_not allow_value('').for(:name) }
    it { expect(feedback).to_not allow_value('').for(:email) }
    it { expect(feedback).to_not allow_value('').for(:callsign) }
    it { expect(feedback).to_not allow_value('').for(:controller) }
    it { expect(feedback).to_not allow_value('').for(:position) }
    it { expect(feedback).to_not allow_value('').for(:service_level) }
    it { expect(feedback).to_not allow_value('').for(:comments) }

  end # describe 'ActiveModel validations'

  describe 'ActiveRecord associations' do
  end # describe 'ActiveRecord associations'

end
