require 'rails_helper'

RSpec.describe 'students/show.json', type: :view do
  shared_context :rendered_template do
    before do
      assign(:student, student)
      render template: 'students/show', format: :json
    end

    it 'renders the student as JSON' do
      expect { JSON.parse(response.body) }.not_to raise_error
    end
  end

  shared_context :student_json do
    let(:json) { JSON.parse response.body }
  end

  shared_examples :common_fields do
    it 'includes the student\'s id' do
      expect(json).to include('id' => subject.id)
    end

    it 'includes the creation timestamp in ISO 8601 format' do
      expect(json).to include('created_at' => subject.created_at.iso8601(3))
    end

    it 'includes the update timestamp in ISO 8601 format' do
      expect(json).to include('updated_at' => subject.updated_at.iso8601(3))
    end
  end

  shared_examples :student_fields do
    subject { student }
    include_examples :common_fields

    it 'includes the student\'s name' do
      expect(json).to include('name' => student.name)
    end
  end

  context 'when a student has no lesson' do
    let(:student) { create(:student) }
    include_context :rendered_template

    describe 'student\'s JSON' do
      include_context :student_json
      include_examples :student_fields

      it 'has a null lesson field' do
        expect(json).to include('lesson' => nil)
      end

      it 'has a null lesson_part field' do
        expect(json).to include('lesson_part' => nil)
      end
    end
  end

  context 'when a student has a lesson' do
    let(:student) { create(:student_with_lesson) }
    include_context :rendered_template

    describe 'student\'s JSON' do
      include_context :student_json
      include_examples :student_fields

      it 'has a lesson object' do
        expect(json).to include('lesson' => instance_of(Hash))
      end

      it 'has a lesson_part object' do
        expect(json).to include('lesson_part' => instance_of(Hash))
      end
    end

    shared_examples :common_number_field do
      it 'has a number field' do
        expect(json).to include('number' => subject.number)
      end
    end

    describe 'student\'s lesson JSON' do
      let(:json) { JSON.parse(response.body)['lesson'] }
      subject { student.lesson }
      include_examples :common_fields
      include_examples :common_number_field
    end

    describe 'student\'s lesson_part JSON' do
      let(:json) { JSON.parse(response.body)['lesson_part'] }
      subject { student.lesson_part }
      include_examples :common_fields
      include_examples :common_number_field
    end
  end
end
