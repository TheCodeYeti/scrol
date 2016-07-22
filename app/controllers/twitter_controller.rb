class TwitterController < ApplicationController
  def index
        client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "gJS2PbF7GizO5zKyfXvXmcZn7"
        config.consumer_secret     = "q7lNXWudAe5Fnc8EfrHscfQjxL6xwjfOJgkrAMYUTb5aMHx0dA"
        config.access_token        = "4892852285-IT6yr3XMg9ubV3ADKhlGMF0VC1PS5O8r7dNZaEE"
        config.access_token_secret = "DAso1ydU9jwFay7P2qeHkSwnK1KL09sFv0p3jyXl6boAq"
      end

      @tweets = client.search('tweet', count: 4, screen_name: 'http://www.twitter.com/@thando20')
  end
end
