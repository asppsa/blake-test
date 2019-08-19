require 'rails_helper'
require_relative './person_helper.rb'

RSpec.describe Student, type: :model do
  let(:lesson) { Lesson.create! number: 1 }
  let(:lesson_part) { LessonPart.create! number: 1, lesson: lesson }

  it_behaves_like 'a person'

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
