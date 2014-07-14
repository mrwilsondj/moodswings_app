class MapDisplayController < ApplicationController
  include MapDisplayHelper

  def index
    @markers = []
    if params[:place].present?
      @friends = current_user.friends.near(params[:place])
      @friends.each do |f|
         marker_data = get_marker_data(f.screen_name, f.name)
         @markers << [marker_data, f.latitude, f.longitude]
      end
    else
      @friends = current_user.friends
      @friends.each do |f|
         marker_data = get_marker_data(f.screen_name, f.name)
         @markers << [marker_data, f.latitude, f.longitude]
      end
    end
  end
end
