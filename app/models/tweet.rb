class Tweet < ActiveRecord::Base
  belongs_to :friend

  def self.exists?(friend_id, twitter_text)
    where(:tweet_text => twitter_text, :friend_id => friend_id).length > 0
  end

   def analysis
      self.result = Datumbox.new.TwitterSentimentAnalysis(text: self.tweet_text)
      self.save!
   end

end
