Rails.application.routes.draw do
  devise_for :users
  root "pages#home"

  get "/about-us", to: "pages#about_us"
  get "/work-with-us", to: "pages#work_with_us"
  get "/contact", to: "pages#contact"
  get "/request-support", to: "pages#request_support"
  get "/manager_dashboard", to: "managers#dashboard"

  resources :supports do
    resources :caregivers, only: [:new, :create]
    member do
      get :manager_support
    end
  end

  resources :caregivers do
    member do
      get :manager_caregiver
    end
  end
end
