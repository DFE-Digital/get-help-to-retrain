Rails.application.routes.draw do
  ActiveAdmin.routes(self) if Rails.env.development?
  mount Flipflop::Engine => '/features' if Rails.env.development?

  get '/pages/:page', to: 'pages#show'

  get '/404', to: 'errors#not_found', via: :all
  get '/422', to: 'errors#unprocessable_entity', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all

  get 'task-list', to: 'pages#task_list'
  get 'find-training-courses', to: 'pages#find_training_courses'
  get 'next-steps', to: 'pages#next_steps'
  get 'maths-course-overview', to: 'pages#maths_overview'
  get 'english-course-overview', to: 'pages#english_overview'

  get 'location-eligibility', to: 'pages#location_eligibility', constraints: ->(_req) { Flipflop.location_eligibility? }

  resources :courses, path: 'courses/:topic_id', only: %i[index], constraints: { topic_id: /maths|english/ }

  resources :check_your_skills, path: 'check-your-skills', only: %i[index] do
    get :results, on: :collection
  end

  resources :job_profiles, path: 'job-profiles', only: %i[show] do
    resources :skills, only: %i[index]
  end

  resources :explore_occupations, path: 'explore-occupations', only: %i[index] do
    get :results, on: :collection
  end

  resources :categories, only: [:show]

  root to: 'home#index'
end
