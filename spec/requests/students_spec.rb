require 'rails_helper'
require_relative './person_helper.rb'

RSpec.describe 'Students', type: :request do
  describe 'GET /students' do
    let!(:students) { create_list(:student_with_lesson, 10) }
    it 'renders the index template' do
      get students_path
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /students/new' do
    it 'renders the new template' do
      get student_path(:new)
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /student/:id/edit' do
    let(:student) { create(:student) }

    it 'renders the edit template' do
      get student_path(student) + '/edit'
      expect(response).to render_template(:edit)
    end
  end

  shared_examples 'a json view' do
    let(:student) { create(:student) }

    it 'returns a JSON representation of the student' do
      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
      expect(response.content_type).to eq 'application/json'
      expect { JSON.parse(response.body) }.not_to raise_error
    end
  end

  describe 'GET /student/:id' do
    context 'normal request' do
      let(:student) { create(:student) }

      it 'redirects to the students page' do
        get student_path(student)
        expect(response).to redirect_to(students_path)
      end
    end

    context 'with Accept: application/json header' do
      before { get student_path(student), headers: { Accept: 'application/json' } }
      it_behaves_like 'a json view'
    end
  end

  describe 'GET /student/:id.json' do
    before { get student_path(student) + '.json' }
    it_behaves_like 'a json view'
  end

  shared_examples 'a student data setter' do
    let(:person) { student }
    include_examples 'a name setter'

    context 'with a lesson part' do
      let(:lesson_part) { create(:lesson_part) }
      let(:data) { { name: 'A Testing', lesson_part_id: lesson_part.id } }

      it 'sets the student\'s data' do
        expect(student.lesson_part).to eq lesson_part
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to(students_path)
      end
    end

    context 'with a teacher' do
      let(:teacher) { create(:teacher) }
      let(:data) { { name: 'A Testing', teacher_id: teacher.id.to_s } }

      it 'sets the student\'s teacher' do
        expect(student.teacher).to eq teacher
      end
    end
  end

  describe 'POST /students' do
    let(:student) { Student.last }

    before { post students_path, params: { student: data } }

    it_behaves_like 'a student data setter'
    include_examples :invalid_name_redirect, :new
  end

  describe 'PUT /student/:id' do
    before do
      put student_path(student.id), params: { student: data }
      student.reload
    end

    context 'with a student with a lesson' do
      let(:student) { create(:student_with_lesson) }
      it_behaves_like 'a student data setter'

      context 'with a blank lesson part param' do
        let(:data) { { lesson_part_id: '' } }

        it 'unsets the student\'s lesson part' do
          expect(student.lesson_part).to be_nil
        end
      end
    end

    context 'with a student with a teacher' do
      let(:student) { create(:student_with_teacher) }
      it_behaves_like 'a student data setter'

      context 'with a blank teacher param' do
        let(:data) { { teacher_id: '' } }

        it 'unsets the student\'s teacher' do
          expect(student.teacher).to be_nil
        end
      end
    end

    context 'with a student without a lesson' do
      let(:student) { create(:student) }

      it_behaves_like 'a student data setter'
      include_examples :invalid_name_redirect, :edit
    end
  end
end
