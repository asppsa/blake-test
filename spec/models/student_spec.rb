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

  describe '#advance_lesson!' do
    it 'initiates a transaction' do
      expect(described_class).to receive(:transaction).at_least(:once)
      create(:student).advance_lesson!
    end

    shared_examples :no_change do
      it 'raises an exception' do
        expect { subject.advance_lesson! }.to raise_error(Student::AdvanceError)
      end

      it 'does not update the student' do
        subject.advance_lesson!
      rescue Student::AdvanceError
        expect(subject.changed?).to be false
      end
    end

    shared_examples :advances do |desc = 'next'|
      it "returns the #{desc} lesson part" do
        expect(subject.advance_lesson!).to eq next_lesson_part
      end

      it "sets the student's lesson part to the #{desc} one" do
        expect { subject.advance_lesson! }
          .to change { subject.lesson_part }
          .from(current_lesson_part)
          .to(next_lesson_part)
      end
    end

    context 'when the student has no current lesson part' do
      subject { create(:student) }

      context 'when there is no initial lesson part' do
        before do
          expect(LessonPart).to receive(:initial).and_return(nil)
        end

        include_examples :no_change
      end

      context 'when there is an initial lesson part' do
        let(:current_lesson_part) { nil }
        let(:next_lesson_part) { create(:lesson_part) }

        before do
          expect(LessonPart).to receive(:initial).and_return(next_lesson_part)
        end

        include_examples :advances, 'initial'
      end
    end

    context 'when the student has a current lesson part' do
      subject { create(:student_with_lesson) }
      let(:current_lesson_part) { subject.lesson_part }

      context 'when there is no next lesson part' do
        include_examples :no_change
      end

      context 'when there is a next lesson part' do
        let!(:next_lesson_part) do
          create :lesson_part,
                 lesson: current_lesson_part.lesson,
                 number: current_lesson_part.number + 1
        end

        include_examples :advances
      end
    end

    context 'when there are 100 lessons with three parts each' do
      let!(:lessons) do
        FactoryBot.rewind_sequences
        create_list(:lesson_with_parts, 100, parts_count: 3)
      end
      let(:lesson_parts) { lessons.flat_map { |lesson| lesson.parts.all } }
      subject { create(:student) }

      it 'enables a student to progress through all lesson parts in order' do
        lesson_parts.each do |lesson_part|
          expect(subject.advance_lesson!).to eq lesson_part
        end
      end

      it 'raises an exception if we attempt to progress beyond the last lesson' do
        expect { (100 * 3).times { subject.advance_lesson! } }.not_to raise_error
        expect { subject.advance_lesson! }.to raise_error Student::AdvanceError
      end
    end
  end
end
