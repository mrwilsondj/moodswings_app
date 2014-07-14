class Tweet < ActiveRecord::Base
  belongs_to :friend

  def self.exists?(friend_id, twitter_text)
    where(:tweet_text => twitter_text, :friend_id => friend_id).length > 0
  end
end
