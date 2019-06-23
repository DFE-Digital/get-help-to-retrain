Rails.application.routes.draw do
  get '/pages/:page', to: 'pages#show'

  get '/404', to: 'errors#not_found', via: :all
  get '/422', to: 'errors#unprocessable_entity', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all

  resources :check_your_skills, only: %i[index] do
    get :results, on: :collection
  end

  root to: 'home#index'
end
