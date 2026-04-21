Rails.application.routes.draw do
  root 'home#index'
  
  # Поиск
  get '/search', to: 'home#search', as: 'search'
  
  # Основной контент франшизы
  get '/franchise/:id/characters', to: 'home#characters', as: 'franchise_characters'
  post '/franchise/:id/characters', to: 'characters#create'
  get '/franchise/:id/glossary', to: 'home#glossary', as: 'franchise_glossary'

  post '/franchise/:id/glossary', to: 'glossaries#create'
  patch '/glossary/:id', to: 'glossaries#update'
  delete '/glossary/:id', to: 'glossaries#destroy'
  
  # Просмотр и редактирование страницы персонажа
  get '/character/:id', to: 'characters#show', as: 'character_profile'
  patch '/character/:id', to: 'characters#update'
  
  # Маршруты карты
  get '/maps/:id', to: 'maps#show', as: 'franchise_map'
  patch '/maps/update_coordinates/:id', to: 'maps#update_coordinates'
  post '/maps/create_node', to: 'maps#create_node'
  patch '/maps/update_node/:id', to: 'maps#update_node'
  delete '/maps/delete_node/:id', to: 'maps#delete_node'

  # Тайтлы и Серии
  resources :works, only: [:show, :update] do
    resources :episodes, only: [:create] 
  end

  resources :episodes, only: [:update, :destroy] do
    member do
      post 'add_character'
      delete 'remove_character/:character_id', to: 'episodes#remove_character', as: 'remove_character'
    end
  end
  
  # Авторизация и ЛК
  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'
  get '/profile', to: 'users#show', as: 'profile'

  # Взаимодействие
  resources :favorites, only: [:create, :destroy]
  resources :reviews, only: [:create, :destroy]
  post '/update_progress', to: 'user_progresses#update_or_create'

  # Админка
  get '/admin', to: 'admin#index'
  get '/admin/episodes/new', to: 'admin#new_episode', as: 'new_episode_admin'
  post '/admin/episodes', to: 'admin#create_episode'
  delete '/admin/episodes/:id', to: 'admin#destroy_episode'
  get '/admin/characters/new', to: 'admin#new_character'
  post '/admin/characters', to: 'admin#create_character'
  get '/admin/characters/:id/edit', to: 'admin#edit_character', as: 'edit_character_admin'
  patch '/admin/characters/:id', to: 'admin#update_character'
  delete '/admin/characters/:id', to: 'admin#destroy_character'
  get '/admin/glossary/new', to: 'admin#new_glossary'
  post '/admin/glossary', to: 'admin#create_glossary'
  get '/admin/works/new', to: 'admin#new_work'
  post '/admin/works', to: 'admin#create_work'
  delete '/admin/works/:id', to: 'admin#destroy_work'
  get '/admin/appearances/new', to: 'admin#new_appearance'
  post '/admin/appearances', to: 'admin#create_appearance'
  delete '/admin/appearances/:id', to: 'admin#destroy_appearance'

  # API
  get '/api/franchises', to: 'api#franchises'
end