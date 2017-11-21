# frozen_string_literal: true

require_relative '../../spec/support/fake_vatusa_api'

# Use the Mock VATUSA API. Even if set to api.vatusa.net by accident in test,
# the rails_helper will still route requests to the FakeVATUSAAPI and fail!
if Rails.application.secrets.vatusa_api_key == 'FAKE_KEY'
  # rubocop:disable Rails/Output
  # Rails logger is not initialized at this point
  puts 'WARNING: Using Fake VATUSA API'
  # rubocop:enable Rails/Output

  Rails.application.config.middleware.use FakeVATUSAAPI
end
