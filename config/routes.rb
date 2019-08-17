Rails.application.routes.draw do
  # Add this redirect for simplicity
  get '/', to: redirect('/students')
  resources :students
end
