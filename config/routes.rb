Rails.application.routes.draw do
  resources :teachers do
    member do
      get 'students'
    end
  end

  # This adds the APIPie interface at /apipie
  apipie

  # Add this redirect for simplicity
  get '/', to: redirect('/students')
  resources :students
end
