Rails.application.routes.draw do
  

  devise_for :users, :controllers => { registrations: 'registrations' }
  get  'home/index' => 'home#index'
  root 'home#index'
  resources :friend_requests, :posts
  resources :users,    :only => [:show, :index]
  resources :likes,    :only => [:create, :destroy]
  resources :comments, :only => [:create, :destroy, :edit, :update]
end