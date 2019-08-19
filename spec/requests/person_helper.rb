# This only specs cases where the request is successful at changing the name.
RSpec.shared_examples 'a name setter' do
  context 'with an acceptable name' do
    let(:data) { { name: 'John Doe' } }

    it 'sets the person\'s name' do
      expect(person.reload.name).to eq 'John Doe'
    end
  end

  context 'with trailing whitespace in the name' do
    let(:data) { { name: 'testing whitespace       ' } }

    it 'trims the whitespace' do
      expect(person.reload.name).to eq 'testing whitespace'
    end
  end

  context 'with leading whitespace in the name' do
    let(:data) { { name: '     testing leading' } }

    it 'trims the whitespace' do
      expect(person.reload.name).to eq 'testing leading'
    end
  end
end

RSpec.shared_examples :invalid_name_redirect do |template|
  context 'with an invalid name' do
    let(:data) { { name: 'a 1213' } }

    it "displays the #{template} template" do
      expect(response).to have_http_status(200)
      expect(response).to render_template(template)
    end
  end
end
