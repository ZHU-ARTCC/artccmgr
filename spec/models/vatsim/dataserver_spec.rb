require 'rails_helper'

RSpec.describe Vatsim::Dataserver, type: :model do

  it 'has a valid factory' do
    expect(build(:vatsim_dataserver)).to be_valid
  end

  let(:dataserver) { build(:vatsim_dataserver) }

  describe 'ActiveModel validations' do

    # Basic validations
    it { expect(dataserver).to validate_presence_of(:url) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(dataserver).to_not allow_value('').for(:url) }

  end # describe 'ActiveModel validations'

end
