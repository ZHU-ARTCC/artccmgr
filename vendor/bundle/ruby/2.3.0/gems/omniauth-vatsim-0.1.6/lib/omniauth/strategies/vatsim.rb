require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Vatsim < OmniAuth::Strategies::OAuth
      option :name, 'vatsim'

      option :client_options, {
        site:               'http://sso.hardern.net/server', # default to demo site
        scheme:             :body,
        authorize_path:     '/auth/pre_login/?',
        request_token_path: '/api/login_token',
        access_token_path:  '/api/login_return',
      }

      uid do
        parse_callback['id']
      end

      info do
        {
          id:           parse_callback['id'],
          name_first:   parse_callback['name_first'],
          name_last:    parse_callback['name_last'],
          rating:       parse_callback['rating'],
          pilot_rating: parse_callback['pilot_rating'],
          email:        parse_callback['email'],
          experience:   parse_callback['experience'],
          reg_date:     parse_callback['reg_date'],
          country:      parse_callback['country'],
          region:       parse_callback['region'],
          division:     parse_callback['division'],
          subdivision:  parse_callback['subdivision']
        }
      end

      # Parse the callback for user information
      def parse_callback
        MultiJson.decode(self.extra['access_token'].params.keys[1])['user']
      end

      # Customize the OAuth request phase to handle VATSIM SSO
      def request_phase
        request_token = consumer.get_request_token({oauth_callback: callback_url}, options.request_params) do |response_body|
          # Debug the response body
          # log :debug, response_body.inspect

          # Log errors
          if MultiJson.decode(response_body)['request']['result'] == 'fail'
            log :error, MultiJson.decode(response_body)['request']['message']
          end

          # symbolize string keys returned by VATSIM SSO
          MultiJson.decode(response_body)['token'].symbolize_keys
        end

        session['oauth'] ||= {}
        session['oauth'][name.to_s] = {
          'callback_confirmed': request_token.callback_confirmed?,
          'request_token':      request_token.token,
          'request_secret':     request_token.secret
        }

        if request_token.callback_confirmed?
          redirect request_token.authorize_url(options[:authorize_params])
        else
          redirect request_token.authorize_url(options[:authorize_params].merge(oauth_callback: callback_url))
        end

      rescue ::Timeout::Error => e
        fail!(:timeout, e)
      rescue ::Net::HTTPFatalError, ::OpenSSL::SSL::SSLError => e
        fail!(:service_unavailable, e)
      end # def request_phase

    end # class Vatsim
  end # module Strategies
end # module OmniAuth
