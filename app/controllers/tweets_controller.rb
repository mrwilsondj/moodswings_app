class TweetsController < ApplicationController
  def index
    @Tweets = Tweet.all
  end

  def show
    client = Twitter::REST::Client.new do |config|
      # config.consumer_key        = "Rd5s5s82FAiUD1KufnrnQ"
      # config.consumer_secret     = "6q8LouMcq8qE1aZa5Mn5nONdwpzchrmXOIlqEYl9CU"
      # # config.access_token        = "#{current_user.oauth_token}"
      # # config.access_token_secret = "#{current_user.oauth_secret}"
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end

    # finding a twitter user
    f = client.user(params[:username])
    location_value = Geocoder.coordinates("#{f.location}")
    friend_model = Friend.save_friend_data(f, location_value, current_user.id)

    get_tweets(client, params[:username]).each { |tweet|
      unless Tweet.exists?(friend_model.id, tweet[:tweet_text])
        new_tweet = Tweet.create(tweet.merge({ :friend_id => friend_model.id }))
        new_tweet.analysis
      end
    }

    @tweets = friend_model.tweets
  end

  # TODO
  # extract to a proper module
  private
  def get_tweets(client, username)
    client.user_timeline(username).take(20).collect do |tweet|
      {
        # :twitter_id => tweet.id.to_s,
        :tweet_text => tweet.text,
        :tweet_date => tweet.created_at
      }
    end
  end
end
