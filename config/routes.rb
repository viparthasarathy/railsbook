Rails.application.routes.draw do
  
  devise_for :users, :controllers => { registrations: 'registrations' }
  get  'home/index' => 'home#index'
  root 'home#index'
  resources :users, :only => [:show, :index]
  resources :friend_requests, :posts
  resources :likes, :comments, :only => [:create, :destroy]
end