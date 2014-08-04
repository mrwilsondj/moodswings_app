class Friend < ActiveRecord::Base
  belongs_to :user
  has_many :tweets

  def self.save_friend_data(friend, user_id)
    self.create_with(
    name: friend.name,
    ).find_or_create_by(user_id: user_id, screen_name: friend.screen_name)
  end

end
