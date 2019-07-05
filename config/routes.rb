Rails.application.routes.draw do
  mount Flipflop::Engine => "/flipflop"
  get '/pages/:page', to: 'pages#show'

  get '/404', to: 'errors#not_found', via: :all
  get '/422', to: 'errors#unprocessable_entity', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all

  get :task_list, to: 'pages#task_list'
  get :find_training_courses, to: 'pages#find_training_courses'
  get :next_steps, to: 'pages#next_steps'

  resources :check_your_skills, only: %i[index] do
    get :results, on: :collection
  end

  resources :job_profiles, only: %i[show] do
    resources :skills, only: %i[index]
  end

  resources :explore_occupations, only: %i[index] do
    get :results, on: :collection
  end

  resources :categories, only: [:show]

  root to: 'home#index'
end
