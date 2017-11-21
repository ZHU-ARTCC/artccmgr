# frozen_string_literal: true

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
        expect(@airport.longitude.to_f).to eq(-95.339722)
      end

      it 'updates the airport charts' do
        expect(@airport.charts.count).to eq 117
      end
    end # context 'it updates the airport information'

    context 'when the airport cannot be found' do
      before :each do
        ActiveJob::Base.queue_adapter = :inline
        @airport = create(:airport, icao: 'XXXX')
      end

      it 'should log the AirCharts error' do
        expect(Rails.logger).to(
          receive(:error).with(
            'AirportUpdateJob: AirCharts: ICAO identifier XXXX not found'
          )
        )
        AirportUpdateJob.perform_now
      end

      it 'should fail gracefully' do
        expect { AirportUpdateJob.perform_now }.to_not raise_error
      end
    end # context 'it should fail gracefully'
  end # describe '#perform'
end # RSpec.describe
