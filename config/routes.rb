Rails.application.routes.draw do
  # 開発環境で送信メールを閲覧する画面 (/letter_opener)
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :users
  root "home#index"

  resources :group_members, only: %i[create]
  resources :groups, only: %i[new create show] do
    resources :rounds, only: %i[new create show] do
      resources :comments, only: %i[create new]
    end
    resources :comments, only: %i[create new]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
