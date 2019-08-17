require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:lesson) { Lesson.create! number: 1 }
  let(:lesson_part) { LessonPart.create! number: 1, lesson: lesson }

  describe 'name' do
    it 'is required by database constraints' do
      expect { Student.create!(name: 'test').update_column(:name, nil) }
        .to raise_error ActiveRecord::NotNullViolation
    end

    it 'validates presence' do
      expect(Student.create(name: nil)).to be_invalid
      expect(Student.create(name: '')).to be_invalid
    end

    it 'validates the alphabetic contents' do
      expect(Student.create(name: 'Jim')).to be_valid
      expect(Student.create(name: 'Jim Jones')).to be_valid
      expect(Student.create(name: '1234Jim')).not_to be_valid
    end

    it 'validates the length' do
      expect(Student.create(name: 'x' * 200)).to be_valid
      expect(Student.create(name: 'x' * 201)).to be_invalid
    end

    it 'allows reading and writing a name' do
      student = Student.create!(name: 'Jim')
      expect { student.name = 'Jim Jones' }
        .to change { student.name }
        .from('Jim')
        .to('Jim Jones')
    end
  end

  describe 'lesson_part' do
    shared_examples :lesson_part do
      it 'can be interrogated' do
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
      end

      it 'does not affect validity' do
        expect { subject.update!(lesson_part: nil) }
          .not_to(change { subject.valid? })
      end
    end

    context 'when set at creation' do
      subject { Student.create! name: 'Joe', lesson_part: lesson_part }
      include_examples :lesson_part
    end

    context 'when set after creation' do
      subject { Student.create! name: 'Joe' }
      before { subject.update! lesson_part: lesson_part }
      include_examples :lesson_part
    end
  end

  describe 'lesson' do
    subject { Student.create! name: 'Joe' }

    it 'is set when the lesson part is set' do
      expect { subject.update! lesson_part: lesson_part }
        .to change { subject.lesson }
        .from(nil)
        .to(lesson)
    end
  end
end
