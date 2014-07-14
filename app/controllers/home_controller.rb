class HomeController < ApplicationController
  def fetch_friend_data
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      # config.access_token        = "#{current_user.oauth_token}"
      # config.access_token_secret = "#{current_user.oauth_secret}"
      config.access_token        = ENV["TWITTER_OAUTH_TOKEN"]
      config.access_token_secret = ENV["TWITTER_OAUTH_SECRET"]
    end

    @friends = client.friends.take(20)

    @friends.each do |f|
      location = f.location
      location_value = Geocoder.coordinates("#{location}")
      if location_value.present?
        friend = Friend.save_friend_data(f, location_value, current_user.id)
        friend.tweets << get_tweets(client, f.screen_name).collect do |tweet|
          Tweet.create({ :friend_id => friend.id }.merge(tweet))
        end
      end
    end
    redirect_to map_display_index_path
  end

  private
  def get_tweets(client, username)
    client.user_timeline(username).take(20).collect do |tweet|
      {
        :user => tweet.user.screen_name,
        :tweet_text => tweet.text,
        :tweet_date => tweet.created_at
      }
    end
  end
end
