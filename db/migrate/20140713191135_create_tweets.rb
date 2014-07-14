class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :twitter_id
      t.text :tweet_text
      t.datetime :tweet_date
      t.integer :friend_id

      t.timestamps
    end
  end
end
