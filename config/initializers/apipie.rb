Apipie.configure do |config|
  config.app_name = 'BlakeTest'
  config.api_base_url = ''
  config.doc_base_url = '/apipie'
  config.translate = false
  # where is your API defined?
  config.api_controllers_matcher = Rails.root.join('app', 'controllers', '**', '*.rb')
end
