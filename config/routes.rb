Rails.application.routes.draw do
  # get "map_display/index"
  get "sessions/create"
  get "tweets/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  match "/auth/:provider/callback" => "sessions#create", via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
  # resource :tweets


end

#              Prefix Verb     URI Pattern                        Controller#Action
#        sessions_create GET      /sessions/create(.:format)         sessions#create
#             home_index GET      /home/index(.:format)              home#index
# home_fetch_friend_data GET      /home/fetch_friend_data(.:format)  home#fetch_friend_data
#                   root GET      /                                  home#index
#                        GET|POST /auth/:provider/callback(.:format) sessions#create
#                signout GET|POST /signout(.:format)                 sessions#destroy
#                 tweets POST     /tweets(.:format)                  tweets#create
#             new_tweets GET      /tweets/new(.:format)              tweets#new
#            edit_tweets GET      /tweets/edit(.:format)             tweets#edit
#                        GET      /tweets(.:format)                  tweets#show
#                        PATCH    /tweets(.:format)                  tweets#update
#                        PUT      /tweets(.:format)                  tweets#update
#                        DELETE   /tweets(.:format)                  tweets#destroy
