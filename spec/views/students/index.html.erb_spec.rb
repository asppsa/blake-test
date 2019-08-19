require 'rails_helper'
require_relative '../person_helper.rb'

RSpec.describe 'students/index', type: :view do
  let(:path) { method(:student_path) }

  before do
    assign(:students, students)
    render
  end

  context 'when students have lessons' do
    let!(:students) { create_list(:student_with_lesson, 10) }
    let(:people) { students }

    it_behaves_like 'a list of people'

    it 'displays students\' lesson numbers' do
      assert_select 'table' do
        students.each do |student|
          assert_select 'td', text: student.lesson_part.display_number
        end
      end
    end
  end

  context 'when students have no lessons' do
    let!(:students) { create_list(:student, 2) }
    let(:people) { students }
    it_behaves_like 'a list of people'

    it 'displays "No current lesson"' do
      assert_select 'table' do
        assert_select 'td', text: 'No current lesson', count: 2
      end
    end
  end
end
