require 'rails_helper'

RSpec.describe AirportUpdateJob, type: :job do

  describe '#perform' do

    it 'queues the job' do
      ActiveJob::Base.queue_adapter = :test
      expect { AirportUpdateJob.perform_later }.to have_enqueued_job
    end

	  context 'it updates the airport information' do
      before :each do
        ActiveJob::Base.queue_adapter = :inline

	      @airport = create(:airport, icao: 'KIAH')
        AirportUpdateJob.perform_now
	      @airport.reload
      end

		  it 'updates the airport elevation' do
			  expect(@airport.elevation).to eq 96
		  end

      it 'updates the airport latitude' do
        expect(@airport.latitude.to_f).to eq 29.980472
      end

		  it 'updates the airport longitude' do
			  expect(@airport.longitude.to_f).to eq -95.339722
		  end

		  it 'updates the airport charts' do
			  expect(@airport.charts.count).to eq 117
		  end

	  end # context 'it updates the airport information'

  end # describe '#perform'

end # RSpec.describe
