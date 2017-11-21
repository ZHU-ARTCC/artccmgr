# frozen_string_literal: true

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

      before :each do
        ActiveJob::Base.queue_adapter = :inline
        User.destroy_all
      end

      it 'adds new members' do
        VatusaRosterSyncJob.perform_now
        expect(User.all.count).to eq 11
      end

      it 'assigns the Controller group to new users' do
        VatusaRosterSyncJob.perform_now
        expect(Group.find_by(name: 'Controller').users.count).to eq 6
      end

      it 'assigns the Controller group to former Guest users' do
        user = create(
          :user,
          cid: 1_300_002,
          group: Group.find_by(name: 'Guest')
        )

        expect do
          VatusaRosterSyncJob.perform_now
          user.reload
        end.to change(user, :group).to(Group.find_by(name: 'Controller'))
      end

      it 'does not change an existing users staff group' do
        user = create(
          :user,
          cid: 1_300_002,
          group: Group.find_by(name: 'Air Traffic Manager')
        )

        expect { VatusaRosterSyncJob.perform_now }.to_not change(user, :group)
      end

      it 'updates staff members' do
        VatusaRosterSyncJob.perform_now
        # rubocop:disable Metrics/LineLength
        expect(Group.find_by(name: 'Air Traffic Manager').users.count).to eq 1
        expect(Group.find_by(name: 'Deputy Air Traffic Manager').users.count).to eq 1
        expect(Group.find_by(name: 'Training Administrator').users.count).to eq 1
        expect(Group.find_by(name: 'Webmaster').users.count).to eq 1
        expect(Group.find_by(name: 'Facility Engineer').users.count).to eq 1
        # rubocop:enable Metrics/LineLength
      end
    end # context 'it updates the airport information'

    context 'invalid url or API key' do
      before :all do
        @api_url = Rails.application.secrets.vatusa_api_url
      end

      after :all do
        Rails.application.secrets.vatusa_api_url = @api_url
      end

      before :each do
        ActiveJob::Base.queue_adapter = :inline
        Rails.application.secrets.vatusa_api_url = 'nohost'
        User.destroy_all
      end

      it 'does not modify the roster' do
        expect { VatusaRosterSyncJob.perform_now }.to_not change(User, :count)
      end

      it 'logs the error' do
        expect(Rails.logger).to receive(:error).with(/VatusaRosterSyncJob:/)
        VatusaRosterSyncJob.perform_now
      end

      it 'fails gracefully' do
        expect { VatusaRosterSyncJob.perform_now }.to_not raise_error
      end
    end # context 'invalid url'

    context 'invalid roster from API' do
      before :each do
        ActiveJob::Base.queue_adapter = :inline
        Settings.artcc_icao = 'XXXX'
        User.destroy_all
      end

      it 'does not modify the roster' do
        expect { VatusaRosterSyncJob.perform_now }.to_not change(User, :count)
      end

      it 'logs the error' do
        expect(Rails.logger).to(
          receive(:error).with(/VatusaRosterSyncJob: Roster ICAO/)
        )
        VatusaRosterSyncJob.perform_now
      end

      it 'fails gracefully' do
        expect { VatusaRosterSyncJob.perform_now }.to_not raise_error
      end
    end # context 'invalid roster from API'
  end # describe '#perform'
end
