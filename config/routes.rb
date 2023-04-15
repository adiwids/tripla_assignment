Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    scope 'user' do
      resources :sleep_cycles, only: %i[index create]
    end
    resources :users, only: :none do
      resources :sleep_cycles, only: :index
    end
  end
end
