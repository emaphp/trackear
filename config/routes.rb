# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions'
  }

  match '/404', to: 'error#not_found', via: :all
  match '/422', to: 'error#unacceptable', via: :all
  match '/500', to: 'error#internal_error', via: :all

  scope 'admin' do
    resources :users do
      post :become, on: :member
    end
  end

  resources :expenses do
    delete '/destroy_invitation/:invitation_id', as: 'destroy_invitation', action: :destroy_invitation, on: :collection
    get '/accept_invitation/:token', as: 'accept_invitation', action: :accept_invitation, on: :collection
    post :send_invitation, on: :collection
    get :download_invoice, on: :member
    get :download_receipt, on: :member
  end

  resources :projects do
    resources :invoice_statuses, only: [] do
      post :confirm_hours, on: :member
    end

    get :status_period, on: :member

    resources :reports
    resources :project_contracts, except: [:index]

    resources :activity_tracks, except: [:index]

    resources :invoices do
      post :add_entries_to_client_invoice, on: :member
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
      get :status, on: :member
    end
  end

  scope 'slack' do
    post 'log', to: 'slack#log'
  end

  get '/solutions', to: 'home#solutions', as: 'home_solutions'
  root to: 'home#index', as: 'home'
end
