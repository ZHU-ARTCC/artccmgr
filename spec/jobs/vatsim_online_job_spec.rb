require 'rails_helper'

RSpec.describe VatsimOnlineJob, type: :job do
  include ActiveJob::TestHelper

  after :each do
	  clear_enqueued_jobs
  end

  it 'queues the job' do
    ActiveJob::Base.queue_adapter = :test
    expect { VatsimOnlineJob.perform_later }.to have_enqueued_job
  end

  context 'before a new update is due' do

    before :each do
      ActiveJob::Base.queue_adapter = :async
	    @data_time    = Time.now
	    @update_time  = Time.now + 2.minutes

	    Vatsim::Dataserver.destroy_all # Delete known servers
    end

    it 'should not download data server information' do
	    expect(
		    VatsimOnlineJob.perform_now(@data_time.to_s, @update_time.to_s)
	    ).to_not have_requested(:get, 'https://status.vatsim.net')
    end

    it 'should not download online user information' do
      expect(
        VatsimOnlineJob.perform_now(@data_time.to_s, @update_time.to_s)
      ).to_not have_requested(:get, /.*\/vatsim-data.txt/)
    end

    it 'should requeue the job' do
		  VatsimOnlineJob.perform_now(@data_time.to_s, @update_time.to_s)
		  expect(enqueued_jobs.size).to eq 1
    end
  end # context 'before a new update is due'

	context 'when no data has been downloaded or an update is due' do

    before :each do
      ActiveJob::Base.queue_adapter = :async
      @data_time    = Time.now - 2.minutes
      @update_time  = Time.now

      Vatsim::Dataserver.destroy_all # Delete known servers
    end

		it 'should download data server information' do
      expect(
        VatsimOnlineJob.perform_now(@data_time.to_s, @update_time.to_s)
      ).to have_requested(:get, 'https://status.vatsim.net')
		end

		it 'should download online user information' do
      expect(
        VatsimOnlineJob.perform_now(@data_time.to_s, @update_time.to_s)
      ).to have_requested(:get, /.*\/vatsim-data.txt/)
		end

    it 'should update controllers that are staffing known positions' do
	    create(:user, cid: 1300012)
	    create(:position, callsign: 'TST_47_CTR', frequency: 121.5)

	    expect{
        VatsimOnlineJob.perform_now(@data_time.to_s, @update_time.to_s)
	    }.to change(Vatsim::Atc, :count).by 1
    end

		it 'should requeue the job for the next update' do
      VatsimOnlineJob.perform_now(@data_time.to_s, @update_time.to_s)
      expect(enqueued_jobs.size).to eq 1
		end

	end # context 'when no data has been downloaded or an update is due'

	context 'when no status URL is configured' do
		before :each do
			ActiveJob::Base.queue_adapter = :async

			Settings.vatsim_status_url = nil
			Vatsim::Dataserver.destroy_all # Delete known servers

			# Stub the sleep call to avoid waiting in real time during tests
			allow_any_instance_of(VatsimOnlineJob).to receive(:sleep).and_return(true)
		end

		it 'should log that it is unable to get new data servers' do
			expect(Rails.logger).to receive(:error).with(/VatsimOnlineJob: Unable to retrieve VATSIM data servers/)
			expect(Rails.logger).to receive(:error).with(/VatsimOnlineJob: No data servers available/)
			VatsimOnlineJob.perform_now
		end

		it 'should retry three times' do
			expect_any_instance_of(VatsimOnlineJob).to receive(:sleep).with(5).exactly(3).times
			VatsimOnlineJob.perform_now
		end

		it 'should fail gracefully' do
			expect{VatsimOnlineJob.perform_now}.to_not raise_error
		end

	end # context '#get_new_data_servers'

	context 'when no data servers could be found' do
		before :each do
			ActiveJob::Base.queue_adapter = :async

			# Stub the sleep call to avoid waiting in real time during tests
			allow_any_instance_of(VatsimOnlineJob).to receive(:sleep).and_return(true)

			# Stub the data download
			allow(VATSIM::Data).to receive(:new).and_raise(StandardError.new('rspec test'))
		end

		it 'should log that it unable to download VATSIM status' do
			expect(Rails.logger).to receive(:error).with(/VatsimOnlineJob: Unable to download VATSIM status/)
			VatsimOnlineJob.perform_now
		end

		it 'should retry three times' do
			expect(VATSIM::Data).to receive(:new).exactly(3).times
			VatsimOnlineJob.perform_now
		end

		it 'should fail gracefully' do
			expect{VatsimOnlineJob.perform_now}.to_not raise_error
		end

	end # context 'when no data servers could be found'

end
