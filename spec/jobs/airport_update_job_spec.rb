require 'rails_helper'

# TODO More complete AirportUpdateJob spec
RSpec.describe AirportUpdateJob, type: :job do

  describe '#perform_later' do

    it 'updates the airport information and charts' do
      ActiveJob::Base.queue_adapter = :test
      expect { AirportUpdateJob.perform_later }.to have_enqueued_job
    end

  end

end
