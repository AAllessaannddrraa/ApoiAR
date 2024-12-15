Rails.application.routes.draw do
  # Devise Authentication
  devise_for :users

  # Página inicial
  root "pages#home"

  # Rotas para páginas estáticas
  get "/about-us", to: "pages#about_us"
  get "/work-with-us", to: "pages#work_with_us"
  get "/contact", to: "pages#contact"
  get "/request-support", to: "pages#request_support"

  # Dashboard Manager
  get "/manager_dashboard", to: "managers#dashboard", as: "manager_dashboard"
  post "/manager_dashboard", to: "managers#dashboard_action"

  # Namespace Manager
  namespace :manager do
    resources :supports, only: [:index, :edit, :update, :show, :destroy] do
      member do
        post :assign_caregiver
      end
    end
  end

  # Supports Resources
  resources :supports do
    resources :caregivers, only: [:new, :create]
    member do
      get :manager_support
      get :calculate_score
      post :assign_caregiver
      post :recalculate_matches
      get :view_matches
    end
    collection do
      post :add_support_to_dashboard
    end
  end

  # Caregivers Resources
  resources :caregivers do
    member do
      get :manager_caregiver
    end
  end

  # Request Supports
  resources :request_supports
end
