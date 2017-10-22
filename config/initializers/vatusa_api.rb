require_relative '../../spec/support/fake_vatusa_api'

# Use the Mock VATUSA API. Even if set to api.vatusa.net by accident in test,
# the rails_helper will still route requests to the FakeVATUSAAPI and fail!
if Rails.application.secrets.vatusa_api_url == 'http://localhost:3000/fakeapi/VATUSA'
	puts 'WARNING: Using Fake VATUSA API'
	Rails.application.config.middleware.use FakeVATUSAAPI
end
