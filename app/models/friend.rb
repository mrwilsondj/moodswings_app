class Friend < ActiveRecord::Base
  belongs_to :user
  has_many :tweets
  geocoded_by :location

  def self.save_friend_data(friend, location_value, user_id)
    if location_value.nil?
      self.create_with(
        name: friend.name,
        location: friend.location,
        latitude: nil,
        longitude: nil,
      ).find_or_create_by(user_id: user_id, screen_name: friend.screen_name)
    else
      self.create_with(
        name: friend.name,
        location: friend.location,
        latitude: location_value.first,
        longitude: location_value.second
      ).find_or_create_by(user_id: user_id, screen_name: friend.screen_name)
    end
  end
end
