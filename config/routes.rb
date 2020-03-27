# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  mount Flipflop::Engine => '/features' if Rails.env.development?

  constraints(AdminConstraint.new) do
    ActiveAdmin.routes(self)

    get '/', to: 'admin/dashboard#index'
    get 'admin/sign-in', to: 'admin/user_sessions#sign_in'
    get 'admin/sign-out', to: 'admin/user_sessions#destroy'
    get '/auth/azure_ad_auth/callback', to: 'admin/auth#callback'
  end

  constraints(UserConstraint.new) do
    get '/pages/:page', to: 'pages#show'

    get '/status', to: 'status#index'

    get '/404', to: 'errors#not_found', via: :all
    get '/422', to: 'errors#unprocessable_entity', via: :all
    get '/500', to: 'errors#internal_server_error', via: :all

    get 'steps', as: :task_list, to: 'pages#task_list'
    get 'cookies-policy', to: 'pages#cookies_policy'
    get 'privacy-policy', to: 'pages#privacy_policy'
    get 'information-sources', to: 'pages#information_sources'
    get 'accessibility-statement', to: 'pages#accessibility_statement'
    get 'terms-and-conditions', to: 'pages#terms_and_conditions'

    get 'action-plan', to: 'pages#action_plan'
    match(
      'jobs-near-you',
      to: 'job_vacancies#index', as: :jobs_near_me, via: %i[get post]
    )
    get 'offers-near-you', as: 'offers-near-me', to: 'pages#offers_near_me'
    get 'cv-advice', to: 'pages#cv_advice'
    get 'cover-letter-advice', to: 'pages#cover_letter_advice'
    get 'interview-advice', to: 'pages#interview_advice'
    get 'training-questions', to: 'questions#training'
    post 'training-questions', to: 'questions#training_answers'
    get 'edit-training-questions', to: 'questions#edit_training'
    post 'edit-training-questions', to: 'questions#edit_training_answers'
    get 'it-training-questions', to: 'questions#it_training'
    post 'it-training-questions', to: 'questions#it_training_answers'
    get 'job-hunting-questions', to: 'questions#job_hunting'
    post 'job-hunting-questions', to: 'questions#job_hunting_answers'
    get 'course-postcode-search-error', to: 'errors#course_postcode_search_error'
    get 'return-to-saved-progress-error',
        as: 'return-to-saved-results-error', to: 'errors#return_to_saved_results_error'
    get 'save-your-progress-error', as: 'save-results-error', to: 'errors#save_results_error'
    get 'location-ineligible', to: 'pages#location_ineligible'
    get 'postcode-search-error', to: 'errors#postcode_search_error'
    get 'jobs-near-you-error', as: 'jobs-near-me-error', to: 'errors#jobs_near_me_error'

    match(
      'courses/:topic_id',
      to: 'courses#index', as: :courses, via: %i[get post], constraints: { topic_id: /maths|english/ }
    )

    constraints(CsvCoursesConstraint.new) do
      match(
        'courses/:topic_id/:course_id/:course_run_id',
        to: 'courses#show', as: :course_details, via: :get, constraints: { topic_id: /maths|english/ }
      )

      get 'courses-near-you-error', as: 'courses-near-me-error', to: 'errors#courses_near_me_error'
    end

    resources :check_your_skills, path: 'check-your-skills', only: %i[index] do
      get :results, on: :collection
    end

    resources :job_profiles, path: 'job-profiles', only: %i[index show destroy] do
      get :results, on: :collection
      post :target, on: :member
      resources :skills do
        get :index, controller: 'job_profiles_skills', on: :collection
      end
    end

    resources :skills_matcher, path: 'job-matches', only: %i[index]

    get 'your-skills', as: :skills, to: 'skills#index'

    get 'your-information', to: 'user_personal_data#index'
    post 'your-information', to: 'user_personal_data#create'

    resources :user_personal_data, only: %i[index create]

    resources :feedback_surveys, only: %i[create]

    get 'save-your-progress', as: 'save-your-results', to: 'users#new'
    post 'save-your-progress', to: 'users#create'
    post 'email-sent-again', to: 'users#registration_send_email_again'

    get 'return-to-saved-progress', as: 'return-to-saved-results', to: 'users#return_to_saved_results'
    post 'return-to-saved-progress', to: 'users#sign_in'
    post 'link-sent-again', to: 'users#sign_in_send_email_again'

    get 'link-expired', to: 'users#link_expired'
    get '/sign-in/:token', to: 'passwordless/sessions#show', authenticatable: 'user', as: :token_sign_in

    post 'update-cookie-preferences', to: 'cookies#update'

    root to: 'home#index'
  end
end
# rubocop:enable Metrics/BlockLength
