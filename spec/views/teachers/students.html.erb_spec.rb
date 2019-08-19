require 'rails_helper.rb'
require_relative '../person_helper.rb'

RSpec.describe 'teachers/students', type: :view do
  let(:people) { teacher.students }
  let(:path) { method(:teacher_path) }

  before(:each) do
    assign(:teacher, teacher)
    assign(:students, teacher.students)
    render
  end

  context 'with no students' do
    let(:teacher) { create(:teacher) }

    it 'displays a "no students" notification' do
      assert_select '.notification', /\bno students\b/i
    end
  end

  context 'with students without progress' do
    let(:teacher) { create(:teacher_with_students) }
    it_behaves_like 'a list of people'
  end

  context 'with students with progress' do
    let(:teacher) { create(:teacher_with_students_and_lessons) }
    it_behaves_like 'a list of people'
  end
end
