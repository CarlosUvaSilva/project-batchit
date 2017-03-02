Rails.application.routes.draw do
  get 'things/create_restaurant'

  get 'things/create_bar'

  get 'things/create_accommodation'

  get 'things/create_activity'

  get 'things/index'

  get 'things/new_scraper'

  get 'participants/index'

  get 'participants/create'

  get 'participants/destroy'

  get 'cities/index'

  get 'cities/new'

  get 'cities/create'

  get 'cities/show'

  get 'cities/new_restaurants'

  get 'cities/new_accommodations'

  get 'cities/new_bars'

  get 'cities/new_activities'

  get 'projects/index'

  get 'projects/show'

  get 'projects/new'

  get 'projects/create'

  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
