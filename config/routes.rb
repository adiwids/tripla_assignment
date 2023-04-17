Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    scope 'user' do
      resources :sleep_cycles, only: %i[index create] do
        put '/', to: 'sleep_cycles#update', on: :collection
      end
      get '/followings', to: 'users#followings'
      get '/followers', to: 'users#followers'
    end
    resources :users, only: :index do
      resources :sleep_cycles, only: :index
      member do
        post :follow
        delete :unfollow
      end
    end
  end
end
