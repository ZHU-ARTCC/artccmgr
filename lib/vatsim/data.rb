require 'csv'
require 'open-uri'
require 'ostruct'

# VATSIM Data File Parsing
#
# Initialization: VATSIM::Data.new('http://vatsim-data.hardern.net/vatsim-data.txt')
#
module VATSIM

	class Data

		attr_reader :url, :raw, :general, :atc, :pilots, :prefile, :servers, :voice

		def initialize(data_url)
			@url = data_url
			@raw = open(data_url.to_s){|f| f.read}
			@raw = @raw.encode!('US-ASCII', 'UTF-8', invalid: :replace, undef: :replace, replace: '?')

			@general  = nil
			@atc      = []
			@pilots   = []
			@servers  = []
			@voice    = []
			@prefile  = []

			begin
				parse_general(@raw.match(/^!GENERAL:\r?\n(.*);/m)[1])
				parse_voice(@raw.match(/^!VOICE SERVERS:\r?\n(.*)!CLIENTS/m)[1])
				parse_clients(@raw.match(/^!CLIENTS:\r?\n(.*)!SERVERS/m)[1])
				parse_servers(@raw.match(/^!SERVERS:\r?\n(.*)!PREFILE/m)[1])
				parse_prefile(@raw.match(/^!PREFILE:\r?\n(.*);\s+END/m)[1])
			rescue NoMethodError
				raise StandardError, 'Unrecognized format returned from: ' + @url
			end

			# Sanity check parsing versus client count
			if @general.clients != (@atc.size + @pilots.size)
				raise StandardError, 'Client count did not match number of parsed ATC and Pilots'
			end
		end # def initialize

		private

		# Convert VATSIM data time string format into Time object
		#
		def convert_time(time_string)
			return nil if time_string.nil?

			format = '%Y%m%d%H%M%S'
			Time.strptime(time_string, format)
		end

		# Parse the clients section of the data file
		#
		def parse_clients(client_text)
			@atc    = []
			@pilots = []

			parse_text(client_text) do |row|
				@atc.push    process_atc(row)   if row[3] == 'ATC'
				@pilots.push process_pilot(row) if row[3] == 'PILOT'
			end
		end

		# Parse the general section of the data file
		#
		def parse_general(general_text)
			@general = OpenStruct.new(
		    version:          general_text.match(/^VERSION = (\d+)/m)[1].to_i,
		    reload:           general_text.match(/^RELOAD = (\d+)/m)[1].to_i,
		    update:           convert_time(general_text.match(/^UPDATE = (\d+)/m)[1]),
		    atis_allow_min:   general_text.match(/^ATIS ALLOW MIN = (\d+)/m)[1].to_i,
		    clients:          general_text.match(/^CONNECTED CLIENTS = (\d+)/m)[1].to_i
			)
		end

		# Parse teh prefile section of the data file
		#
		def parse_prefile(prefile_text)
			@prefile = []

			parse_text(prefile_text) do |row|
				@prefile.push process_prefile(row)
			end
		end

		# Parse the servers section of the data file
		#
		def parse_servers(servers_text)
			@servers = []

			parse_text(servers_text) do |row|
				@servers.push (
          OpenStruct.new(
						ident:            row[0],
						hostname:         row[1],
						location:         row[2],
						name:             row[3],
						clients_allowed:  (row[4] == '1' ? true : false),
				))
			end
		end

		# Parses colon delimited text into rows
		#
		# Example:
		#   parse_section('colon:delimited:text')
		def parse_text(text)
			CSV.parse(text, col_sep: ':', quote_char: "\x00") do |row|
				yield row
			end
		end

		# Parse the voice servers section of the data file
		#
		def parse_voice(voice_text)
			@voice = []

			parse_text(voice_text) do |row|
				@voice.push (
          OpenStruct.new(
						hostname:         row[0],
						location:         row[1],
						name:             row[2],
						clients_allowed:  (row[3] == '1' ? true : false),
						type:             row[4]
				))
			end
		end

		# Process each ATC row of the data file
		#
		def process_atc(row)
			OpenStruct.new(
				callsign:   row[0],
				cid:        row[1].to_i,
				name:       row[2],
				frequency:  row[4],
				latitude:   row[5].to_f,
				longitude:  row[6].to_f,
				server:     row[14],
				rating:     row[16].to_i,
				facility:   row[18].to_i,
				range:      row[19].to_i,
				atis:       row[35],
				atis_time:  convert_time(row[36]),
				logon_time: convert_time(row[37])
			)
		end

		# Process each PILOT row of the data file
		#
		def process_pilot(row)
			OpenStruct.new(
				callsign:     row[0],
				cid:          row[1].to_i,
				name:         row[2],
				latitude:     row[5].to_f,
				longittude:   row[6].to_f,
				altitude:     row[7].to_i,
				groundspeed:  row[8].to_i,
				aircraft:     row[9],
				planned_tas:  row[10].to_i,
				origin:       row[11],
				planned_alt:  row[12],
				destination:  row[13],
				server:       row[14],
				rating:       row[16].to_i,
				transponder:  row[17],
				flight_type:  (row[21] == 'I' ? :ifr : :vfr),
				remarks:      row[29],
				route:        row[30],
				logon_time:   convert_time(row[37]),
				heading:      row[38].to_i,
				altimeter:    row[39].to_f
			)
		end

		# Process each PREFILE row of the data file
		#
		def process_prefile(row)
			OpenStruct.new(
					callsign:     row[0],
					cid:          row[1].to_i,
					name:         row[2],
					aircraft:     row[9],
					planned_tas:  row[10].to_i,
					origin:       row[11],
					planned_alt:  row[12],
					destination:  row[13],
					rating:       row[16].to_i,
					revision:     row[20].to_i,
					flight_type:  (row[21] == 'I' ? :ifr : :vfr),
					dep_time:     row[22],
					hrs_enroute:  row[24],
					mins_enroute: row[25],
					hrs_fuel:     row[26],
					mins_fuel:    row[27],
					alternate:    row[28],
					remarks:      row[29],
					route:        row[30]
			)
		end

	end # class Data

end # module VATSIM
