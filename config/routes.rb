Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, :skip => [:registrations]
  scope 'admin' do
    resources :users
  end
  resources :projects do
    resources :project_contracts, except: [:index]
    resources :invoices do
      post :make_visible, on: :member
      post :hide, on: :member
    end
    resources :activity_tracks, except: [:index]
  end
  root to: "home#index", as: 'home'
end
