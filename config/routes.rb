# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  ActiveAdmin.routes(self) if Rails.env.development?
  mount Flipflop::Engine => '/features' if Rails.env.development?

  get '/pages/:page', to: 'pages#show'

  get '/404', to: 'errors#not_found', via: :all
  get '/422', to: 'errors#unprocessable_entity', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all

  get 'task-list', to: 'pages#task_list'
  get 'next-steps', to: 'pages#next_steps'

  get 'maths-course-overview', to: 'pages#maths_overview'
  get 'english-course-overview', to: 'pages#english_overview'
  get 'training-hub', to: 'pages#training_hub'
  get 'course-postcode-search-error', to: 'errors#course_postcode_search_error'

  get 'location-eligibility', to: 'pages#location_eligibility'
  get 'location-ineligible', to: 'pages#location_ineligible'
  get 'postcode-search-error', to: 'errors#postcode_search_error'

  resources :courses, path: 'courses/:topic_id', only: %i[index], constraints: { topic_id: /maths|english/ }

  resources :check_your_skills, path: 'check-your-skills', only: %i[index] do
    get :results, on: :collection
  end

  resources :job_profiles, path: 'job-profiles', only: %i[show] do
    resources :skills do
      get :index, controller: 'job_profiles_skills', on: :collection
    end
  end

  resources :skills_matcher, path: 'job-matches', only: %i[index]
  resources :skills, only: %i[index]

  root to: 'home#index'
end
# rubocop:enable Metrics/BlockLength
