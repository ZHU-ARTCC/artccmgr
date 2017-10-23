require 'open-uri'

# VATSIM Status File Parsing
#
# Initialization: VATSIM::Status.new('https://status.vatsim.net')
#
module VATSIM

	class Status

		attr_reader :url, :raw, :msg, :data, :servers, :metar, :atis, :user

		def initialize(status_url)
			@url = status_url
			@raw = open(status_url.to_s){|f| f.read}
			@raw = @raw.encode!('US-ASCII', 'UTF-8', invalid: :replace, undef: :replace, replace: '?')

			begin
				@msg      = find('msg0=')
				@data     = find('url0=')
				@servers  = find('url1=')
				@metar    = find('metar0=')
				@atis     = find('atis0=')
				@user     = find('user0=')
			rescue NoMethodError
				raise StandardError, 'Unrecognized format returned from: ' + @url
			end
		end

		private

		def find(section)
			url_array = @raw.split(/\r?\n/)
			url_array.collect!{|u| u.match(/^#{section}.*/)}
			url_array.reject!{|u| u.nil?}
			process_urls(section, url_array) unless url_array.empty?
		end

		def process_urls(match_criteria, url_array)
			array = []
			url_array.each do |url|
				array.push url.to_s.split(match_criteria.to_s)[1]
			end
			array
		end

	end # class Data

end # class VATSIM
