Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, :skip => [:registrations]
  resources :users
  resources :projects do
    resources :project_contracts, except: [:index]
    resources :invoices
    resources :activity_tracks, except: [:index]
  end
  root to: "home#index", as: 'home'
end
