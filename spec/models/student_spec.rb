require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'name' do
    it 'is required by validation' do
      expect(Student.create).to be_invalid
      expect(Student.create(name: '')).to be_invalid
    end

    it 'is required by database constraints' do
      expect { Student.create!(name: 'test').update_column(:name, nil) }
        .to raise_error ActiveRecord::NotNullViolation
    end

    it 'is required to be wordy' do
      expect(Student.create(name: 'Jim')).to be_valid
      expect(Student.create(name: '1234Jim')).not_to be_valid
    end

    it 'allows reading and writing a name' do
      student = Student.create!(name: "Jim")
      expect(student.name).to eq 'Jim'
    end
  end

  describe 'lesson_part' do
    let(:lesson) { Lesson.create! number: 1 }
    let(:lesson_part) { LessonPart.create! number: 1, lesson: lesson }
    subject { Student.create! name: 'Joe', lesson_part: lesson_part }

    it 'can be set and interrogated' do
      expect(subject.lesson_part).to eq lesson_part
    end

    it 'provides access to the Lesson' do
      expect(subject.lesson).to eq lesson
    end

    it 'can be unset' do
      expect { subject.update!(lesson_part: nil) }
        .to change { subject.lesson_part }
        .from(lesson_part)
        .to(nil)

      expect(subject.lesson).to be_nil
    end
  end
end
