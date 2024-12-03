Rails.application.routes.draw do
  devise_for :users
  resources :supports do
    resources :caregivers, only: [:new, :create]
  end

  # Outras rotas
  root 'pages#home'

  resources :caregivers do
    member do
      get 'manager_caregiver'
    end
  end

  resources :supports do
    member do
      get 'manager_support'
    end
  end

  get 'work-with-us', to: 'pages#work_with_us'
  get 'request-support', to: 'pages#request_support'
  get 'contact', to: 'pages#contact'
  get 'about-us', to: 'pages#about_us'
  get 'manager_dashboard', to: 'managers#dashboard', as: :manager_dashboard
end
