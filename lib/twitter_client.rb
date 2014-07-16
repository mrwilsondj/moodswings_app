def get_twitter_client()
  Twitter::REST::Client.new do |config|
    config.consumer_key        = 'Rd5s5s82FAiUD1KufnrnQ'
    config.consumer_secret     = '6q8LouMcq8qE1aZa5Mn5nONdwpzchrmXOIlqEYl9CU'

    config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token        = ENV["TWITTER_OAUTH_TOKEN"]
    config.access_token_secret = ENV["TWITTER_OAUTH_SECRET"]
  end
end

