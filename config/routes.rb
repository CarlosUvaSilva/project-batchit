Rails.application.routes.draw do
  resources :projects, only: [:index, :show, :new, :create] do
    resources :participants, only: [:index, :create, :destroy]
    resources :cities, only: [:show, :new, :create]
  end


  devise_for :users
  root to: 'pages#home'

  resources :things, only: [:index]





  get 'cities/:id/new_scraper', to: "things#new_scraper", as: "new_scraper"

  post 'cities/:id/create_restaurant', to: "things#create_restaurant", as: "create_restaurant"
  post 'cities/:id/create_bar', to: "things#create_bar", as: "create_bar"
  post 'cities/:id/create_accommodation', to: "things#create_accommodation", as: "create_accommodation"
  post 'cities/:id/create_activity', to: "things#create_activity", as: "create_activity"

  get 'cities/:id/new_restaurants', to: "cities#new_restaurants", as: "new_city_restaurants"
  get 'cities/:id/new_accommodations', to: "cities#new_accommodations", as: "new_city_accommodations"
  get 'cities/:id/new_bars', to: "cities#new_bars", as: "new_city_bars"
  get 'cities/:id/new_activities', to: "cities#new_activities", as: "new_city_activities"


  get 'projects/:id/dashboard', to: "projects#dashboard", as: "project_dashboard"



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
