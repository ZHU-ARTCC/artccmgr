require 'rails_helper'

# TODO More complete MetarJob spec
RSpec.describe MetarJob, type: :job do

	describe '#perform_later' do

		it 'updates the Weather' do
			ActiveJob::Base.queue_adapter = :test
			expect { MetarJob.perform_later }.to have_enqueued_job
		end

	end

end
