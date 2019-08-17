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
end
