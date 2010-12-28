require 'omniauth/oauth'
require 'multi_json'

# https://github.com/intridea/omniauth/tree/master/oa-oauth/lib/omniauth/strategies
# http://intridea.github.com/omniauth/OmniAuth/Strategies/OAuth.html

module OmniAuth
  module Strategies
    #
    # Authenticate to Wepay via OAuth and retrieve basic user information.
    # Usage:
    #    use OmniAuth::Strategies::Wepay, 'consumerkey', 'consumersecret'
    #
    class Wepay < OmniAuth::Strategies::OAuth
      def initialize(app, consumer_key = nil, consumer_secret = nil, options = {}, &block)
        consumer_options = nil
        if Rails.env == "production"
          consumer_options = {
            :site               => 'https://wepayapi.com',
            :request_token_path => "/v1/oauth/request_token",
            :access_token_path  => "/v1/oauth/access_token",
            :authorize_path => "/v1/oauth/authorize"
          }
        else
          consumer_options = {
            :site               => 'http://sandbox.wepayapi.com',
            :request_token_path => "/v1/oauth/request_token",
            :access_token_path  => "/v1/oauth/access_token",
            :authorize_path => "/v1/oauth/authorize"
          }
        end

        super(app, :wepay, consumer_key, consumer_secret, 
              consumer_options, options, &block)
      end
      
      def request_phase
        request_token = consumer.get_request_token(:oauth_callback => callback_url)
        (session['oauth']||={})[name.to_s] = {'callback_confirmed' => request_token.callback_confirmed?, 'request_token' => request_token.token, 'request_secret' => request_token.secret}
        r = Rack::Response.new

        if request_token.callback_confirmed?
          r.redirect(request_token.authorize_url)
        else
          r.redirect(request_token.authorize_url(:oauth_callback => callback_url))        
        end

        r.finish
      end

      def user_data
        @data ||= MultiJson.decode(@access_token.get('/v1/user').body)['result']
      end

      def user_info
        {
          'user_id' => user_data["user_id"],
          'first_name' => user_data["firstName"],
          'last_name' => user_data["lastName"],
          'name' => "#{user_data['firstName']} #{user_data['lastName']}",
          'email' => user_data['email'],
          'picture' => user_data['picture'],
          'registered' => user_data['registered']
        }
      end      

      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
          'uid' => user_data['user_id'],
          'user_info' => user_info
        })
      end      
    end
  end
end
