# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  ActiveAdmin.routes(self) if Rails.env.development?
  mount Flipflop::Engine => '/features' if Rails.env.development?

  get '/pages/:page', to: 'pages#show'

  get '/status', to: 'status#index'

  get '/404', to: 'errors#not_found', via: :all
  get '/422', to: 'errors#unprocessable_entity', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all

  get 'task-list', to: 'pages#task_list'
  get 'next-steps', to: 'pages#next_steps'
  get 'cookies-policy', to: 'pages#cookies_policy'
  get 'privacy-policy', to: 'pages#privacy_policy'

  get 'action-plan', to: 'pages#action_plan', constraints: ->(_req) { Flipflop.action_plan? }
  match(
    'jobs-near-me',
    to: 'job_vacancies#index', as: :jobs_near_me, via: %i[get post], constraints: ->(_req) { Flipflop.action_plan? }
  )
  get 'maths-course-overview', to: 'pages#maths_overview'
  get 'english-course-overview', to: 'pages#english_overview'
  get 'training-hub', to: 'pages#training_hub'
  get 'offers-near-me', to: 'pages#offers_near_me', constraints: ->(_req) { Flipflop.action_plan? }
  get 'course-postcode-search-error', to: 'errors#course_postcode_search_error'
  get 'return-to-saved-results-error', to: 'errors#return_to_saved_results_error'

  get 'location-ineligible', to: 'pages#location_ineligible'
  get 'postcode-search-error', to: 'errors#postcode_search_error'
  get 'jobs-near-me-error', to: 'errors#jobs_near_me_error', constraints: ->(_req) { Flipflop.action_plan? }

  match(
    'courses/:topic_id',
    to: 'courses#index', as: :courses, via: %i[get post], constraints: { topic_id: /maths|english/ }
  )

  resources :check_your_skills, path: 'check-your-skills', only: %i[index] do
    get :results, on: :collection
  end

  resources :job_profiles, path: 'job-profiles', only: %i[show destroy] do
    post :target, on: :member, constraints: ->(_req) { Flipflop.action_plan? }
    resources :skills do
      get :index, controller: 'job_profiles_skills', on: :collection
    end
  end

  resources :skills_matcher, path: 'job-matches', only: %i[index]
  resources :skills, only: %i[index]

  get 'your-information', to: 'user_personal_data#index'
  post 'your-information', to: 'user_personal_data#create'

  resources :user_personal_data, only: %i[index create]

  get 'save-your-results', to: 'users#new'
  post 'save-your-results', to: 'users#create'
  post 'email-sent-again', to: 'users#registration_send_email_again'

  get 'return-to-saved-results', to: 'users#return_to_saved_results'
  post 'return-to-saved-results', to: 'users#sign_in'
  post 'link-sent-again', to: 'users#sign_in_send_email_again'

  get 'link-expired', to: 'users#link_expired'
  get '/sign-in/:token', to: 'passwordless/sessions#show', authenticatable: 'user', as: :token_sign_in

  root to: 'home#index'
end
# rubocop:enable Metrics/BlockLength
