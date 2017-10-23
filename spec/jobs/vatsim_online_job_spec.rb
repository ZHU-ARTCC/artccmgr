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

end
