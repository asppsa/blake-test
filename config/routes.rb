Rails.application.routes.draw do
  resources :teachers
  # This adds the APIPie interface at /apipie
  apipie

  # Add this redirect for simplicity
  get '/', to: redirect('/students')
  resources :students
end
