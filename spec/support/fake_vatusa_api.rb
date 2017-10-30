require 'sinatra/base'

class FakeVATUSAAPI < Sinatra::Base

	USERS = {
			# CID 1300001 reserved for testing transfers
			1300002 => { fname: '2nd',  lname: 'Test', rating: '2'  },
			1300003 => { fname: '3rd',  lname: 'Test', rating: '3'  },
			1300004 => { fname: '4th',  lname: 'Test', rating: '4'  },
			1300005 => { fname: '5th',  lname: 'Test', rating: '5'  },
			1300006 => { fname: '6th',  lname: 'Test', rating: '6'  },
			1300007 => { fname: '7th',  lname: 'Test', rating: '7'  },
			1300008 => { fname: '8th',  lname: 'Test', rating: '8'  },
			1300009 => { fname: '9th',  lname: 'Test', rating: '9'  },
			1300010 => { fname: '10th', lname: 'Test', rating: '10' },
			1300011 => { fname: '11th', lname: 'Test', rating: '11' },
			1300012 => { fname: '12th', lname: 'Test', rating: '12' },
	}

	get '/fakeapi/VATUSA/:api_key/cbt/block' do
		content_type :json
		status 200
		{
			status: 'success',
			blocks: [
					id:       '195',
					order:    '1',
					name:     'Test CBT Block',
					visible:  '1'
			]
		}.to_json
	end

	get '/fakeapi/VATUSA/:api_key/cbt/block/:block_id' do
		content_type :json

		if params['block_id'].to_i == 195
			{
				status:     'success',
			  blockId:    '195',
			  blockName:  'Test CBT Block',
			  chapters: [
					  id:     '12',
					  order:  '1',
					  name:   'Test CBT Chapter',
					  url:    'http://www.youtube.com/watch?v=812571259'
			  ]
			}.to_json
		else
			status 404
		end
	end

	get '/fakeapi/VATUSA/:api_key/cbt/chapter/:chapter_id' do
		content_type :json

		if params['chapter_id'].to_i == 12
			{
				status: 'success',
			  chapter: {
					  id:       '12',
					  blockId:  '195',
					  order:    '1',
					  name:     'Test CBT Chapter',
					  url:      'http://www.youtube.com/watch?v=812571259',
			  }
			}.to_json
		else
			status 404
		end
	end

	put '/fakeapi/VATUSA/:api_key/cbt/progress/:cid' do
		if params['chapterId'] == '12'
			status 200
		else
			status 500
		end
	end

	get '/fakeapi/VATUSA/:api_key/controller/:cid' do
		content_type :json

		if USERS.keys.include? params['cid'].to_i
			{
					status:   'success',
					fname:    USERS[params['cid'].to_i][:fname],
					lname:    USERS[params['cid'].to_i][:lname],
					facility: Settings.artcc_icao,
					rating:   USERS[params['cid'].to_i][:rating],
					join_date:      '2014-05-14 18:00:00',
					last_activity:  Time.now.strftime('%Y-%m-%d %H:%M:%S')
			}.to_json
		else
			status 404
		end
	end

	get '/fakeapi/VATUSA/:api_key/exam/results/:cid' do
		content_type :json

		if USERS.keys.include? params['cid'].to_i
			{
					status: 'success',
					cid: params['cid'],
					exams: [
							{
									id:     '18307',
									name:   'VATUSA - Basic ATC Quiz',
									score:  rand(75..100).to_s,
									passed: true,
									date:   '2009-09-14 04:17:37'
							},
							{
									id:     '37094',
									name:   'VATUSA - S2 Rating (TWR) Controller Exam',
									score:  rand(75..100).to_s,
									passed: true,
									date:   '2009-09-27 19:32:42'
							}
					]
			}.to_json
		else
			status 404
		end
	end

	# TODO VATSIM API - validate result ID is really the ID from /exam/results/:cid
	get '/fakeapi/VATUSA/:api_key/exam/result/:result_id' do
		content_type :json

		if params['result_id'].to_i == 18307
			{
					id:     '18307',
					cid:    USERS.keys[rand(USERS.keys.size)].to_s,
					name:   'VATUSA - S2 Rating (TWR) Controller Exam',
					score:  rand(75..100).to_s,
					passed: '1',
					date:   '2009-09-14 04:17:37',
					questions: [
							{
									question:   'The international radio telephony distress signal that ' +
															'indicates imminent and grave danger and that immediate ' +
															'assistance is requested is what?',
									correct:    'Mayday',
									selected:   'Mayday',
									is_correct: true
							}
					]
			}.to_json
		elsif params['result_id'].to_i == 37094
			{
					id:     '18307',
					cid:    USERS.keys[rand(USERS.keys.size)].to_s,
					name:   'VATUSA - Basic ATC Quiz',
					score:  rand(75..100).to_s,
					passed: '1',
					date:   '2009-09-14 04:17:37',
					# questions: [
					# 		{
					# 				question:   'The international radio telephony distress signal that ' +
					# 										'indicates imminent and grave danger and that immediate ' +
					# 										'assistance is requested is what?',
					# 				correct:    'Mayday',
					# 				selected:   'Mayday',
					# 				is_correct: true
					# 		}
					# ]
			}.to_json
		else
			status 404
		end
	end

	get '/fakeapi/VATUSA/:api_key/roster' do
		content_type :json

		roster = []
		USERS.each_pair do |vatsim_id, user|
			roster.push({
				cid:    vatsim_id.to_s,
				fname:  user[:fname],
				lname:  user[:lname],
				email:  'noreply@vatsim.net',
				rating: user[:rating]
			})
		end

		{
				status: 'success',
				facility: {
						id:   'ZTV',
						url:  'https://artccmgr.herokuapp.com',
						name: Settings.artcc_name,
						atm:  '1300012',
						datm: '1300011',
						ta:   '1300010',
						ec:   '1300009',
						wm:   '1300008',
						fe:   '1300007',
						roster: roster
				}
		}.to_json
	end

	delete '/fakeapi/VATUSA/:api_key/roster/:cid' do
		if !params['by'].nil? && !params['msg'].nil? && !params['msg'].blank?
			if USERS.keys.include? params['cid'].to_i
				status 200
			else
				status 404
			end
		else
			status 500
		end
	end

	get '/fakeapi/VATUSA/:api_key/transfer' do
		content_type :json

		{
				status: 'success',
				transfers: [
						{
								id:             '14',
								cid:            '1300001',
								fname:          '1st',
								lname:          'Test',
								rating:         '1',
								rating_short:   'OBS',
								email:          'noreply@vatsim.net',
								from_facility:  'ZXX',
								reason:         'This is a test transfer only.',
								submitted:      Time.now.strftime('%Y-%m-%d')
						}
				]
		}.to_json
	end

	post '/fakeapi/VATUSA/:api_key/transfer/:id' do
		content_type :json

		if !params['action'].nil? && !params['by'].nil?
			if params['action'] == 'accept'
				status 200
			elsif params['action'] == 'reject'
				if !params['reason'].nil?
					status 200
				else
					status 500
				end
			else
				status 500
			end
		else
			status 500
		end
	end

end
