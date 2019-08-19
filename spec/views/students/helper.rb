require_relative '../person_helper.rb'

RSpec.shared_context :view_lessons_stub do
  let(:lessons) { create_list(:lesson_with_parts, 100) }

  # #lessons is declared as a helper_method.  This magic is required to stub
  # the helper.
  before do
    without_partial_double_verification do
      allow(view).to receive(:lessons).and_return(lessons)
    end
  end
end

RSpec.shared_examples 'a student form' do
  let(:name) { 'student' }
  include_examples 'a person form'

  it 'displays a drop-down listing available lessons' do
    assert_select 'select[name=?]', 'student[lesson_part_id]' do
      assert_select 'option[value=""]', 'No Current Lesson'
      lessons.each do |lesson|
        assert_select 'optgroup[label=?]', lesson.display_number do
          lesson.parts.each do |part|
            assert_select 'option[value=?]', part.id.to_s
          end
        end
      end
    end
  end
end
