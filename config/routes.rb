Rails.application.routes.draw do
  root 'home#index'
  
  # Поиск
  get '/search', to: 'home#search', as: 'search'
  
  # Основной контент
  get '/guide/:id', to: 'home#guide', as: 'guide'
  get '/franchise/:id/characters', to: 'home#characters', as: 'franchise_characters'
  get '/franchise/:id/glossary', to: 'home#glossary', as: 'franchise_glossary'
  get '/character/:id', to: 'home#character_show', as: 'character_profile'
  
  # Просмотр тайтла и серий
  get '/work/:id', to: 'home#work_show', as: 'work_profile'
  
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

  # Управление эпизодами
  get '/admin/episodes/new', to: 'admin#new_episode', as: 'new_episode_admin'
  post '/admin/episodes', to: 'admin#create_episode'
  delete '/admin/episodes/:id', to: 'admin#destroy_episode'
  
  # Управление персонажами
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
end