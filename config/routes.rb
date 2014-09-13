Vk::Application.routes.draw do
  root 'static_pages#index'

  resources :users,    except: [:new, :edit]
  resources :sessions, only: [:create, :destroy]

  match 'logout',      to: 'sessions#destroy',         via: :delete

  match 'edit',        to: 'users#edit',               via: :get
  match 'settings',    to: 'users#settings',           via: :get
  match 'restore',     to: 'static_pages#restore',     via: :get

  match 'about',       to: 'static_pages#about',       via: :get
  match 'terms',       to: 'static_pages#terms',       via: :get
  match 'people',      to: 'static_pages#people',      via: :get
  match 'communities', to: 'static_pages#communities', via: :get
  match 'developers',  to: 'static_pages#developers',  via: :get

end
