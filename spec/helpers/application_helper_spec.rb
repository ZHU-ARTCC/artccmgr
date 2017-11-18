require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

	describe '#active_class' do

		it 'returns "active" if the current page matches the link path' do
			allow(helper).to receive(:current_page?).and_return(true)
			expect(helper.active_class(root_path)).to eq 'active'
		end

		it 'returns a blank string if the current page does not match the link path' do
			allow(helper).to receive(:current_page?).and_return(false)
			expect(helper.active_class(root_path)).to eq ''
		end

	end # describe '#active_class'

end