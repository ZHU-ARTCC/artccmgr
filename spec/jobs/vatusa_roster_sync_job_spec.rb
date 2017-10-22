require 'rails_helper'

RSpec.describe VatusaRosterSyncJob, type: :job do

	describe '#perform' do

    it 'queues the job' do
      ActiveJob::Base.queue_adapter = :test
      expect { VatusaRosterSyncJob.perform_later }.to have_enqueued_job
    end

    context 'it updates the roster' do
	    after :all do
		    ActiveJob::Base.queue_adapter = :test
	    end

	    before :all do
		    User.destroy_all
	    end

      before :each do
        ActiveJob::Base.queue_adapter = :inline
        VatusaRosterSyncJob.perform_now
      end

      it 'adds new members' do
        expect(User.all.count).to eq 11
      end

	    it 'updates staff members' do
		    expect(Group.find_by(name: 'Air Traffic Manager').users.count).to eq 1
		    expect(Group.find_by(name: 'Deputy Air Traffic Manager').users.count).to eq 1
		    expect(Group.find_by(name: 'Training Administrator').users.count).to eq 1
		    expect(Group.find_by(name: 'Webmaster').users.count).to eq 1
		    # Facility Engineer is intentional not set to test open positions
		    expect(Group.find_by(name: 'Facility Engineer').users.count).to eq 0
	    end

    end # context 'it updates the airport information'

  end # describe '#perform'

end
