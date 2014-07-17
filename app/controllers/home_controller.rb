

class HomeController < ApplicationController
  def index
    if not params[:username].nil?
     client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
      end

      # try to find a twitter user
      # if the user is not found, the 'twitter' gem raises an error
      begin
        f = client.user(params[:username])
      rescue Exception => error
        # "catches" the error and allow the program to resume without crashing
        # and assigning the error message to a variable to be used to display it in the view
        @error_message = error.message
      end

      # if an error was raised (the user is not found on twitter), don't run the below code
      # only run the below code if the user was successfully found (no error was thrown by f = client.user(params[:username]))
      if not f.nil?
        location_value = Geocoder.coordinates("#{f.location}")
        friend_model = Friend.save_friend_data(f, location_value, current_user.id)

        begin
          get_tweets(client, params[:username]).each do |tweet|
            unless Tweet.exists?(friend_model.id, tweet[:tweet_text])
              new_tweet = Tweet.create(tweet.merge({ :friend_id => friend_model.id }))
              new_tweet.analysis
            end
          end
        rescue Exception => error
          @error_message = error.message
        end

        positive_tweets = friend_model.tweets.select { |tweet| tweet.result == 'positive' }
        negative_tweets = friend_model.tweets.select { |tweet| tweet.result == 'negative' }

        total = positive_tweets.length + negative_tweets.length

        if total > 0
          @name = friend_model.screen_name
          @positivity_percentage = (positive_tweets.length.to_f / total * 100).ceil
          @tweets = friend_model.tweets
        end
      end
    end
  end

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
        :tweet_text => tweet.text,
        :tweet_date => tweet.created_at
      }
    end
  end
end
