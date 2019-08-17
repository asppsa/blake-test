require 'rails_helper'

RSpec.describe 'students/index', type: :view do
  before do
    assign(:students, students)
    render
  end

  shared_examples 'a list of students' do
    it 'displays student names' do
      assert_select 'table' do
        students.each do |student|
          assert_select 'td', text: student.name
        end
      end
    end
  end

  context 'when students have lessons' do
    let!(:students) { create_list(:student_with_lesson, 10) }
    it_behaves_like 'a list of students'

    it 'displays students\' lesson numbers' do
      assert_select 'table' do
        students.each do |student|
          assert_select 'td', text: student.lesson_part.display_number
        end
      end
    end

    it 'displays a link to #new' do
      assert_select 'a[href=?]', student_path(:new)
    end
  end

  context 'when students have no lessons' do
    let!(:students) { create_list(:student, 2) }
    it_behaves_like 'a list of students'

    it 'displays "No current lesson"' do
      assert_select 'table' do
        assert_select 'td', text: 'No current lesson', count: 2
      end
    end
  end
end
