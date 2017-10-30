require 'rails_helper'

# TODO More complete MetarJob spec
RSpec.describe MetarJob, type: :job do

	describe '#perform_later' do
		it 'enqueues a job' do
			ActiveJob::Base.queue_adapter = :test
			expect { MetarJob.perform_later }.to have_enqueued_job
		end
	end # describe '#perform_later'

	context 'updating weather' do
		before :all do
			ActiveJob::Base.queue_adapter = :inline
		end

		describe 'with an invalid ICAO identifier' do
			before do
				create(:airport, icao: 'XTST')
				allow(Metar::Station).to receive(:find_by_cccc).and_return(nil)
			end

			it 'logs the error' do
				expect(Rails.logger).to receive(:error).with(/MetarJob: Unable to retrieve METAR for/)
				MetarJob.perform_now
			end

			it 'fails gracefully' do
				expect{MetarJob.perform_now}.to_not raise_error
			end

		end # describe 'with an invalid ICAO identifier'

		describe 'encountering an error caused by the Metar library' do
			before do
				@icao = 'XTST'
				@msg  = 'This is an RSpec test'
				create(:airport, icao: @icao)
				allow(Metar::Station).to receive(:find_by_cccc).and_raise(StandardError, @msg)
			end

			it 'logs the error' do
				expect(Rails.logger).to receive(:error).with("MetarJob: Unable to update weather for #{@icao}: #{@msg}")
				MetarJob.perform_now
			end

			it 'fails gracefully' do
				expect{MetarJob.perform_now}.to_not raise_error
			end
		end # describe 'with an error caused by the Metar library'

		describe '#format_altimeter' do
			before do
				@airport = create(:airport, icao: 'XTST')
			end

			it 'does not save a weather object when barometer value is missing' do
				raw    = Metar::Raw::Metar.new 'XTST 311718Z 14011G15KT 10SM BKN030 BKN070 27/18 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather).to eq nil
			end

			it 'returns the altimeter setting as a float' do
				raw    = Metar::Raw::Metar.new 'XTST 311718Z 14011G15KT 10SM BKN030 BKN070 27/18 A3006 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather.altimeter).to eq 30.06
			end
		end # '#format_altimeter'

		describe '#format_rules' do
			before do
				@airport = create(:airport, icao: 'XTST')
			end

			it 'determines LIFR by ceiling' do
				raw = Metar::Raw::Metar.new 'XTST 311718Z 14011G15KT 10SM BKN004 BKN070 27/18 A3006 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather.rules).to eq 'LIFR'
			end

			it 'determines LIFR by visibility' do
				raw = Metar::Raw::Metar.new 'XTST 311718Z 14011G15KT 1/2SM FEW020 BKN070 27/18 A3006 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather.rules).to eq 'LIFR'
			end

			it 'determines IFR by ceiling' do
				raw = Metar::Raw::Metar.new 'XTST 311718Z 14011G15KT 10SM OVC006 BKN070 27/18 A3006 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather.rules).to eq 'IFR'
			end

			it 'determines IFR by visibility' do
				raw = Metar::Raw::Metar.new 'XTST 311718Z 14011G15KT 2SM FEW020 BKN070 27/18 A3006 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather.rules).to eq 'IFR'
			end

			it 'determines MVFR by ceiling' do
				raw = Metar::Raw::Metar.new 'XTST 311718Z 14011G15KT 10SM BKN020 BKN070 27/18 A3006 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather.rules).to eq 'MVFR'
			end

			it 'determines MVFR by visibility' do
				raw = Metar::Raw::Metar.new 'XTST 311718Z 14011G15KT 4SM BKN060 BKN070 27/18 A3006 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather.rules).to eq 'MVFR'
			end

			it 'determines VFR' do
				raw = Metar::Raw::Metar.new 'XTST 311718Z 14011G15KT 6SM BKN040 BKN070 27/18 A3006 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather.rules).to eq 'VFR'
			end
		end # describe '#format_rules'

		describe '#format_wind' do
			before do
				@airport = create(:airport, icao: 'XTST')
			end

			it 'determines variable winds' do
				raw = Metar::Raw::Metar.new 'XTST 311718Z VRB11KT 6SM BKN040 BKN070 27/18 A3006 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather.wind).to eq 'VRB@11'
			end

			it 'determines wind gusts' do
				raw = Metar::Raw::Metar.new 'XTST 311718Z 13011G15KT 6SM BKN040 BKN070 27/18 A3006 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather.wind).to eq '130@11G15'
			end

			it 'determines calm wind' do
				raw = Metar::Raw::Metar.new 'XTST 311718Z 01002KT 6SM BKN040 BKN070 27/18 A3006 RMK AO2 RAB01E12 P0000 T02670183'
				parser = Metar::Parser.new(raw)
				allow(Metar::Station).to receive(:find_by_cccc).and_return(OpenStruct.new(parser: parser))
				MetarJob.perform_now
				expect(@airport.weather.wind).to eq 'Calm'
			end

		end # describe '#format_wind'

	end # context 'updating weather'

end
