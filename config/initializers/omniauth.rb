module OmniAuth
  module Strategies
    # tell OmniAuth to load our strategy
    autoload :Wepay, 'lib/wepay'
  end
end

Rails.application.config.middleware.use OmniAuth::Strategies::Wepay, 
  ENV['WEPAY_CONSUMER_KEY'], ENV['WEPAY_SHARED_SECRET']
