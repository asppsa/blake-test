require 'rails_helper'
require_relative './person_helper.rb'

RSpec.describe 'Teachers', type: :request do
  describe 'GET /teachers' do
    let!(:teachers) { create_list(:teacher, 10) }

    it 'renders the index template' do
      get teachers_path
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /teachers/new' do
    it 'renders the new template' do
      get teacher_path(:new)
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /teacher/:id/edit' do
    let(:teacher) { create(:teacher) }

    it 'renders the edit template' do
      get teacher_path(teacher) + '/edit'
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET /teacher/:id' do
    let(:teacher) { create(:teacher) }

    it 'redirects to the teachers page' do
      get teacher_path(teacher)
      expect(response).to redirect_to(teachers_path)
    end
  end

  describe 'POST /teachers' do
    let(:person) { Teacher.last }

    before { post teachers_path, params: { teacher: data } }

    it_behaves_like 'a name setter'
    include_examples :invalid_name_redirect, :new
  end

  describe 'PUT /teacher/:id' do
    let(:person) { create(:teacher) }

    before { put teacher_path(person), params: { teacher: data } }

    it_behaves_like 'a name setter'
    include_examples :invalid_name_redirect, :edit
  end
end
