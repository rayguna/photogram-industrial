Rails.application.routes.draw do
  root "photos#index"

  devise_for :users

  resources :likes
  resources :follow_requests
  resources :comments
  resources :photos
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get ":username/liked" => "photos#liked", as: :liked_photos
  get ":username/feed" => "photos#feed", as: :feed_photos
  get ":username/followers" => "photos#followers", as: :followers_photos
  get ":username/following" => "photos#following", as: :following_photos

  get ":username" => "users#show", as: :user

end 
