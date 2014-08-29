Vk::Application.routes.draw do
  root 'static_pages#index'

  resources :users
  resources :sessions, only: [:create, :destroy]

  match 'restore',     to: 'static_pages#restore',     via: :get

  match 'about',       to: 'static_pages#about',       via: :get
  match 'terms',       to: 'static_pages#terms',       via: :get
  match 'people',      to: 'static_pages#people',      via: :get
  match 'communities', to: 'static_pages#communities', via: :get
  match 'developers',  to: 'static_pages#developers',  via: :get

end
