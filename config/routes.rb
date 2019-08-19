Rails.application.routes.draw do
  root to: 'pages#main'

  resources :students
  resources :teachers do
    member do
      get 'students'
    end
  end

  # This adds the APIPie interface at /apipie
  apipie
end
