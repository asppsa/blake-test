Rails.application.routes.draw do
  # This adds the APIPie interface at /apipie
  apipie

  # Add this redirect for simplicity
  get '/', to: redirect('/students')
  resources :students
end
