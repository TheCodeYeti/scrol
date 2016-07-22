class TwitterController < ApplicationController
  def index
        client = Twitter::REST::Client.new do |config|
          config.consumer_key = Rails.application.secrets.twitter_consumer_key
          config.consumer_secret = Rails.application.secrets.twitter_consumer_secret
          config.access_token = Rails.application.secrets.twitter_access_token
          config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
        end

      @tweets = client.search('tweets', count: 10, limit: 4, screen_name: 'http://www.twitter.com/thandon20')

  end

end
