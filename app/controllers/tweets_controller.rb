class TweetsController < ApplicationController

   def index
    if not params[:username].nil?
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV["TEMP_TWITTER_CONSUMER_KEY"]
          config.consumer_secret     = ENV["TEMP_TWITTER_CONSUMER_SECRET"]
          # config.consumer_key        = "HMpg5BgwQAlnbzbPZNUjk4THh"
          # config.consumer_secret     = "hlZkZ0xZ2OhwlhZtpsC5sQYbA0H7CXT1Gb5pHziNUZ2n79Q3C7"
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
         friend_model = Friend.save_friend_data(f, current_user.id)

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

  private
  def get_tweets(client, username)
    client.user_timeline(username).take(5).collect do |tweet|
      {:tweet_text => tweet.text,
      :tweet_date => tweet.created_at}
    end
  end

end

