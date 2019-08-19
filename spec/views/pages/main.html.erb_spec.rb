require 'rails_helper'

RSpec.describe 'pages/main.html.erb', type: :view do
  it 'renders successfully' do
    expect { render }.not_to raise_error
  end
end
