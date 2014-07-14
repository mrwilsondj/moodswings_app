Rails.application.routes.draw do
  get "map_display/index"
  get "sessions/create"
  get "home/index"
  get "home/fetch_friend_data"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  match "/auth/:provider/callback" => "sessions#create", via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
  resource :tweets


end

#                 Prefix Verb     URI Pattern                        Controller#Action
#      map_display_index GET      /map_display/index(.:format)       map_display#index
#             home_index GET      /home/index(.:format)              home#index
#                        GET      /map_display/index(.:format)       map_display#index
#        sessions_create GET      /sessions/create(.:format)         sessions#create
#                        GET      /home/index(.:format)              home#index
# home_fetch_friend_data GET      /home/fetch_friend_data(.:format)  home#fetch_friend_data
#                   root GET      /                                  home#index
#                        GET|POST /auth/:provider/callback(.:format) sessions#create
#                signout GET|POST /signout(.:format)                 sessions#destroy
