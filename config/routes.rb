Rails.application.routes.draw do
  resources :transactions
  resources :reviews
  resources :users
  resources :books do
    get :filter, on: :collection
  end
  resources :sessions, only: [:new, :create, :destroy]
  root 'home#index'
  get 'signup', to: "users#new", as: 'signup'
  get 'login', to: "sessions#new", as: 'login'
  get 'logout', to: "sessions#destroy", as: 'logout'
  get '/books/:id', to: 'books#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
