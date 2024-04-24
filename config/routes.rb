Rails.application.routes.draw do
  resources :posts
  resources :zip_codes
  resources :users
  post :create_token, to: "users#create_token"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
