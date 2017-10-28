require 'rails_helper'

RSpec.describe ActivityHelper, type: :helper do

	describe '#activity_minimums_css' do

		context 'for staff' do
      before :each do
        @user = create(:user, group: create(:group, staff: true))
      end

      it 'returns bg-danger if the user has not met the minimum requirements' do
        expect(activity_minimums_css(@user, 0)).to eq 'bg-danger'
      end

      it 'returns nil if the user has met the the minimum requirements' do
        required_hours = Settings.activity_hours_staff
        expect(activity_minimums_css(@user, required_hours)).to be_nil
      end
		end # context 'for staff'

		context 'for local controllers' do
      before :each do
	      @user = create(:user, group: create(:group))
      end

      it 'returns bg-danger if the user has not met the minimum requirements' do
        expect(activity_minimums_css(@user, 0)).to eq 'bg-danger'
      end

			it 'returns nil if the user has met the minimum requirements' do
				required_hours = Settings.activity_hours
				expect(activity_minimums_css(@user, required_hours)).to be_nil
			end
		end # context 'for controllers'

		context 'for visiting controllers' do
			before :each do
				@user = create(:user, group: create(:group, visiting: true))
			end

			it 'returns bg-danger if the user has not met the minimum requirements' do
				expect(activity_minimums_css(@user, 0)).to eq 'bg-danger'
			end

			it 'returns nil if the user has met the minimum requirements' do
				required_hours = Settings.activity_hours_visiting
				expect(activity_minimums_css(@user, required_hours)).to be_nil
			end
		end # context 'for visiting controllers'

	end # describe '#activity_minimums_css'

	describe '#report_controls' do

		it 'returns a previous month link' do
			last_month = (Date.today - 1.month).beginning_of_month

			assign(:report_start, Time.now.beginning_of_month)
			assign(:report_end, Time.now.end_of_month)
			expect(helper.report_controls[:prev]).to eq activity_index_path(start_date: last_month)
		end

		it 'returns a next month link if the end time is less than now' do
			start_time = (Time.now - 2.months).beginning_of_month
			end_time   = (Time.now - 2.months).end_of_month
			next_month = (Date.today - 1.month).beginning_of_month

			assign(:report_start, start_time)
			assign(:report_end, end_time)
			expect(helper.report_controls[:next]).to eq activity_index_path(start_date: next_month)
		end

		it 'does not return a next month link if the end time is greater than or equal to now' do
			start_time  = Time.now.beginning_of_month
			end_time    = Time.now.end_of_month

			assign(:report_start, start_time)
			assign(:report_end, end_time)
			expect(helper.report_controls[:next]).to be_nil
		end

	end # describe '#report_controls'

end
