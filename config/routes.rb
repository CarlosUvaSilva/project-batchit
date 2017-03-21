Rails.application.routes.draw do
  get 'errors/not_found'

  get 'errors/internal_server_error'


  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  resources :projects, only: [:index, :show, :new, :create] do
    resources :participants, only: [:index, :create, :destroy]
    resources :cities, only: [:show, :new, :create]
    resources :messages, only: [:create]
    post 'finalize', on: :member
  end


  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'pages#home'

  resources :things, only: [:index] do
    post 'voting', on: :member
    post 'search', on: :collection
  end



  # get 'vote/:id', to: "things#vote", as: "vote"
  # get 'vote3/:id', to: "things#vote3", as: "vote3"

  # get 'unvote/:id', to: "things#unvote", as: "unvote"


  post 'cities/:id/create_restaurant', to: "things#create_restaurant", as: "create_restaurant"
  post 'cities/:id/create_bar', to: "things#create_bar", as: "create_bar"
  post 'cities/:id/create_accommodation', to: "things#create_accommodation", as: "create_accommodation"
  post 'cities/:id/create_activity', to: "things#create_activity", as: "create_activity"


  get 'cities/:id/new_things', to: "cities#new_things", as: "new_city_things"


  get 'projects/:id/dashboard', to: "projects#dashboard", as: "project_dashboard"



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
