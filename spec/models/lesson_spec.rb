require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'parts' do
    subject { described_class.create! number: 1 }

    it 'is a one-to-many association with LessonPart' do
      expect do
        (1..3).each do |number|
          LessonPart.create! number: number, lesson: subject
        end
      end
        .to change { subject.reload.parts }
        .from(be_empty)
        .to(a_collection_containing_exactly(
              an_object_matching(proc { |o| o.number == 1 }),
              an_object_matching(proc { |o| o.number == 2 }),
              an_object_matching(proc { |o| o.number == 3 })
            ))
    end

    it 'always returns LessonParts in numbered order' do
      unordered_numbers = [5, 7, 6, 4, 2, 1, 3]
      unordered_numbers.each do |number|
        LessonPart.create! number: number, lesson: subject
      end

      expect(LessonPart.order(:id).pluck(:number)).to eq unordered_numbers
      expect(subject.parts.pluck(:number)).to eq unordered_numbers.sort
    end
  end

  describe '#next' do
    context 'when there is a next lesson' do
      let(:lessons) { create_list(:lesson, 100) }

      it 'returns the next lesson' do
        99.times do
          lesson = lessons.shift
          expect(lesson.next).to eq lessons.first
          expect(lesson.next.number).to eq lesson.number + 1
        end
      end
    end

    context 'when this is the last lesson' do
      let(:lesson) { create(:lesson) }

      it 'returns nil' do
        expect(lesson.next).to be_nil
      end
    end

    context 'when there is a gap' do
      let(:lessons) { [create(:lesson, number: 1), create(:lesson, number: 3)] }

      it 'returns nil' do
        expect(lessons.first.next).to be_nil
      end
    end
  end
end
