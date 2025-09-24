Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'signup', to: 'auth#signup'
      post 'login', to: 'auth#login'

      get 'users/me', to: 'users#me'
      
      # ✅ Added :create to allow POST /users
      resources :users, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
