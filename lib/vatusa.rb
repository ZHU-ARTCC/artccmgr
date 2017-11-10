require 'httparty'
require 'ostruct'

# VATUSA API
#
# Initialization: api = VATUSA::API.new('https://api.vatusa.net', 'KEY')
#
module VATUSA

	class API
		include HTTParty

		attr_reader :url, :key, :base_url

		# Initialize new API object for manipulating the VATUSA API
		#
		# Arguments:
		#   url:  String containing URL for the API (Example: 'https://api.vatusa.net')
		#   key:  String containing API KEY (Example: 'abcd123')
		#
		def initialize(url, key)
			@url = url
			@key = key
			@base_url = "#{@url}/#{@key}"
		end

		# Retrieve all available CBT blocks associated with your API key
		#
		# Returns Array of OpenStruct objects with the following methods:
		#   id:       CBT Block ID (Example: '195')
		#   order:    Ordering sequence of the CBT (Example: '1')
		#   name:     Name of the CBT block (Example: 'Test CBT Block')
		#   visible: '1' (Visible) or '0' (Hidden)
		#
		def cbt_blocks
			response = self.class.get(@base_url + '/cbt/block')
			check_response(response)['blocks'].collect{|b| OpenStruct.new(b)}
		end # def cbt_blocks

		# Get all chapters associated with a CBT block, block must be
		# associated with your API key
		#
		# Returns OpenStruct object with the following methods:
		#   id:       CBT Block ID (Example: '195')
		#   name:     The name of the CBT Block (Example: 'Test CBT Block')
		#   chapters: Array of OpenStruct objects representing chapters with methods:
		#             id:     Chapter ID (Example: '12')
		#             order:  Ordering sequence of the chapter (Example: '1')
		#             name:   Name of the chapter (Example: 'Test CBT Chapter')
		#             url:    URL to chapter content (Example: 'http://example.com')
		#
		def cbt_block(block_id)
			response = self.class.get(@base_url + '/cbt/block/' + block_id.to_s)
			response = check_response(response)

			id       = response.delete 'blockId'
			name     = response.delete 'blockName'
			chapters = response.delete('chapters').collect{|c| OpenStruct.new(c)}

			OpenStruct.new( id: id, name: name, chapters: chapters)
		end # def cbt_block

		# Get chapter information. Associated block must be associated with your API key.
		#
		# Returns OpenStruct object with the following methods:
		#   id:      CBT Chapter ID (Example: '12')
		#   blockId: CBT Block ID (Example: '195')
		#   order:   Ordering sequence of the chapter (Example: '1')
		#   name:    Name of the chapter (Example: 'Test CBT Chapter')
		#   url:     URL to chapter content
		#
		def cbt_chapter(chapter_id)
			response = self.class.get(@base_url + '/cbt/chapter/' + chapter_id.to_s)
			response = check_response(response)

			OpenStruct.new(response['chapter'])
		end

		# Add CBT chapter completion.
		#
		# Arguments:
		#   cid:        VATSIM ID of student (Example: 1300001)
		#   chapter_id: Completed chapter ID (Example: 12)
		#
		# Returns true if successful. Otherwise Raises exception.
		#
		def cbt_progress(cid, chapter_id)
			headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
			body    = { chapterId: chapter_id.to_s }

			response = self.class.put(@base_url + '/cbt/progress/' + cid.to_s, query: body, headers: headers)
			check_response(response)
			true
		end

		# Get information for a controller
		#
		# Returns OpenStruct object of response with the following methods:
		#   fname:          First name
		#   lname:          Last name
		#   facility:       ICAO of member facility
		#   rating:         Rating expressed as integer
		#   join_date:      Time of date joined VATUSA
		#   last_activity:  Time of last activity on VATUSA
		#
		def controller(cid)
			response = self.class.get(@base_url + '/controller/' + cid.to_s)
			response = check_response(response)

			controller = response.to_h
			# Clean up response hash
			controller.delete 'status' # purge the response status form the hash
			controller['rating']        = controller['rating'].to_i
			controller['join_date']     = Time.parse(controller['join_date'] + ' UTC')
			controller['last_activity'] = Time.parse(controller['last_activity'] + ' UTC')

			OpenStruct.new(controller)
		end

		# Request exam results for a CID, this will return all completed exams.
		#
		# Returns Array of OpenStruct objects for each completed exam with the
		# following methods:
		#   id:     Exam ID (Example: '18307')
		#   name:   Name of the exam (Example: 'VATUSA -  Basic ATC Quiz')
		#   score:  Result score (Example: '88')
		#   passed: Boolean whether test resulted in a pass or fail (Example: true)
		#   date:   Time object representing the date of the exam
		#
		def exam_results(cid)
			response = self.class.get(@base_url + '/exam/results/' + cid.to_s)
			response = check_response(response)

			if response['cid'] == cid.to_s
				results = []

				response['exams'].each do |exam|
					exam['date'] = Time.parse(exam['date'] + ' UTC')
					results.push OpenStruct.new(exam)
				end

				results
			else
				raise ResponseError, "VATSIM API returned incorrect exam result set for: #{cid}"
			end
		end

		# Request a specific exam result by result ID
		#
		# Returns OpenStruct Object with the following methods:
		#   id:     Exam result ID (Example: '18307')
		#   cid:    VATSIM ID of test taker (Example: '1300006')
		#   name:   Name of exam (Example: 'VATUSA - Basic ATC Quiz')
		#   score:  Result score (Example: '84')
		#   passed: Boolean whether test resulted in a pass or fail (Example: true)
		#   date:   Time object representing the date of the exam
		#
		#   Note: Questions may not be available if there was not any data available.
		#         Results from the old site did not contain convertible data, so individual
		#         exam results data will not be available and "questions" will not be defined
		#         at all.
		#   questions: Array containing objects with the following methods:
		#     question:   String containing question text
		#     correct:    String containing the correct answer
		#     selected:   String containing the answer the student selected
		#     is_correct: Boolean whether the question was correct or incorrect
		#
		def exam_result(result_id)
			response = self.class.get(@base_url + '/exam/result/' + result_id.to_s)
			response = check_response(response)

			# Fix consistency issues with passed attribute returning true/false in exam_results
			# versus returning 0 or 1 here.
			response['passed'] = !response['passed'].to_i.zero?
			response['date']   = Time.parse(response['date'] + ' UTC')

			# Convert questions to OpenStruct objects (if questions exist)
			if response.has_key? 'questions'
				response['questions'] = response.delete('questions').collect{|q| OpenStruct.new(q)}
			end

			OpenStruct.new(response)
		end

		# Retrieve the roster associated with your API key
		#
		# Returns OpenStruct object with the following methods:
		#   staff:  OpenStruct object with the following methods:
		#           atm:  Array of Air Traffic Managers OpenStructs
		#           datm: Array of Deputy Air Traffic Managers OpenStructs
		#           ta:   Array of Training Administrators OpenStructs
		#           ec:   Array of Events Coordinator OpenStructs
		#           wm:   Array of Web Master OpenStructs
		#           fe:   Array of Facility Engineer OpenStructs
		#
		#   Each of the staff OpenStruct arrays contain objects with the following methods:
		#           cid:    Integer of member VATSIM ID
		#           name:   String containing full first and last name, example: "John Doe"
		#           rating: Integer representation of VATSIM Rating
		#
		#   members:  Array of OpenStruct objects containing members of the ARTCC
		#             with the following methods:
		#             cid:          Integer of VATSIM CID
		#             fname:        String containing first name
		#             lname:        String containing last name
		#             email:        String containing email
		#             rating:       Integer representation of member rating
		#             rating_short: String containing short name for rating, example: "C1"
		#
		def roster
			response = self.class.get(@base_url + '/roster')
			response = check_response(response)

			response.delete 'status'
			response['facility'] = process_roster_facility(response['facility'])

			OpenStruct.new(response['facility'])
		end

		# Remove the CID from the facility associated with the API key
		#
		# Arguments:
		#   cid:        VATSIM ID of member to delete
		#   staff_cid:  VATSIM ID of staff member making deletion
		#   message:    String containing reason for deletion
		#
		# Returns true if successful. Otherwise Raises exception.
		#
		def roster_delete(cid, staff_cid, message)
			headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
			body    = { by: staff_cid.to_s, msg: message.to_s }

			response = self.class.delete(@base_url + '/roster/' + cid.to_s, query: body, headers: headers)
			check_response(response)
			true
		end

		# Retrieve the pending transfers associated with your API key
		#
		# Returns an Array of OpenStruct objects for pending inbound transfers
		# with the following methods:
		#   id:             Integer containing Transfer request ID (Example: '14')
		#   cid:            Integer containing VATSIM ID of member requesting transfer (Example: 1300001)
		#   fname:          String containing first name of member
		#   lname:          String containing last name of member
		#   rating:         Integer representation of rating (Example: 1)
		#   email:          String containing member email address
		#   from_facility:  String containing ICAO of origin ARTCC
		#   reason:         String containing reason for transfer request
		#   submitted:      Date of transfer request
		#
		def transfers
			response = self.class.get(@base_url + '/transfer')
			response = check_response(response)

			response['transfers'].collect{|t| process_transfer_entry(t) }
		end

		# Process a transfer request
		#
		# Arguments:
		#   transfer_request_id: Integer of transfer request (found from #transfers)
		#   staff_cid:           Integer containing VATSIM ID of staff approving request
		#   action:              Symbol: Either :accept or :reject
		#   reason:              String containing reason (required if action :reject)
		#
		def transfer(transfer_request_id, staff_cid, action, reason = nil)
			raise ArgumentError, 'Reason required' if action == :reject && reason.to_s.blank?
			headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
			url     = @base_url + '/transfer/' + transfer_request_id.to_s

			case action
				when :accept
					body = { action: action.to_s, by: staff_cid.to_s }
				when :reject
					body = { action: action.to_s, by: staff_cid.to_s, reason: reason.to_s }
				else
					raise ArgumentError, "Unknown action: '#{action}'"
			end

			response = self.class.post(url, query: body, headers: headers)
			check_response(response)
			true
		end

		private

		# Checks for a 200 OK response and returns the response object.
		# Otherwise raises a ResponseError exception.
		#
		def check_response(response)
			if response.code == 200
				response
			else
				raise ResponseError, "Response returned status code #{response.code}"
			end
		end

		# Process the facility subsection response from '/roster'
		#
		def process_roster_facility(facility)
			facility['staff'] = process_roster_staff(facility['staff'])

			facility['roster'].collect!{|c| process_roster_member(c)}
			facility['members'] = facility.delete 'roster' # rename the roster key to members
			facility
		end

		# Process an entry of the roster
		#
		def process_roster_member(member)
			member['cid']    = member['cid'].to_i
			member['rating'] = member['rating'].to_i
			OpenStruct.new(member)
		end

		# Process roster staff entries
		#
		def process_roster_staff(staff)
			hash = {}

			staff.each_pair do |role, users|
				hash[role] = users.collect{|u| OpenStruct.new(u)}
			end

			return OpenStruct.new(hash)
		end

		# Process an entry of the transfer request list
		#
		def process_transfer_entry(entry)
			entry['id']         = entry['id'].to_i
			entry['cid']        = entry['cid'].to_i
			entry['rating']     = entry['rating'].to_i
			entry['submitted']  = Date.parse(entry['submitted'])
			OpenStruct.new(entry)
		end

		class ResponseError < StandardError; end;

	end # class API

end # module VATSIM
