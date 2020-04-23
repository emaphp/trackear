# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions' }, skip: [:registrations]

  scope 'admin' do
    resources :users do
      post :become, on: :member
    end
  end

  resources :expenses

  resources :projects do
    resources :reports
    resources :project_contracts, except: [:index]
    resources :activity_tracks, except: [:index]
    resources :invoices do
      post :make_internal, on: :member
      post :make_client, on: :member
      post :email_notify, on: :member
      post :make_visible, on: :member
      post :hide, on: :member
      post :upload_invoice, on: :member
      post :upload_payment, on: :member
      get :download_invoice, on: :member
      get :download_payment, on: :member
      get :review_entries, on: :member
    end
  end

  scope 'slack' do
    post 'log', to: 'slack#log'
  end

  root to: 'home#index', as: 'home'
end
