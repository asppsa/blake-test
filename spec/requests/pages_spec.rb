require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /' do
    it 'renders the homepage' do
      get root_path
      expect(response).to have_http_status(200)
      expect(response).to render_template(:main)
    end
  end
end
