require 'rails_helper'

RSpec.describe LessonPart, type: :model do
  let(:lesson) { Lesson.create! number: 1 }

  describe 'lesson' do
    it 'validates the presence of a Lesson object' do
      expect(LessonPart.create(number: 1)).not_to be_valid
      expect(LessonPart.create(number: 1, lesson: lesson)).to be_valid
    end
  end

  describe 'students' do
    let(:students) { (0...5).map { Student.create! name: 'Jim' } }
    subject { LessonPart.create! number: 1, lesson: lesson }

    it 'is a list of students currently using this lesson part' do
      expect do
        students.each { |student| student.update! lesson_part: subject }
      end
        .to change { subject.reload.students }
        .from(be_empty)
        .to a_collection_containing_exactly(*students)
    end

    it "sets students' lesson parts to null if deleted" do
      students.each { |student| student.update! lesson_part: subject }
      subject.destroy
      expect(students.map(&:reload).map(&:lesson_part)).to all be_nil
    end
  end
end
