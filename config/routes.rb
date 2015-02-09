Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  get  'home/index' => 'home#index'
  root 'home#index'
  resources :users
end