Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :user_sessions, only: [:create]
      resources :users, only: [:create] do
        put :upload_images, on: :collection
        get :get_images, on: :collection
      end
    end
  end
end
