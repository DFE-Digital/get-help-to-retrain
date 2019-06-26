Rails.application.routes.draw do
  get '/pages/:page', to: 'pages#show'

  get '/404', to: 'errors#not_found', via: :all
  get '/422', to: 'errors#unprocessable_entity', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all

  get :task_list, to: 'home#task_list'
  get :find_training_courses, to: 'home#find_training_courses'

  resources :check_your_skills, only: %i[index] do
    get :results, on: :collection
  end

  resources :job_profiles, only: %i[show] do
    get :skills, on: :member
  end

  resources :explore_occupations, only: %i[index] do
    get :results, on: :collection
  end

  resources :categories, only: [:show]

  root to: 'home#index'
end
