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

  describe '#next' do
    context 'when there is a next lesson in this lesson part' do
      let(:lesson) { create(:lesson_with_parts) }
      subject { lesson.parts.first }

      it 'returns the next lesson part in the lesson' do
        expect(subject.next.number).to eq subject.number + 1
        expect(subject.next.lesson).to eq lesson
      end
    end

    context 'when this is the last lesson in this lesson part' do
      let(:lessons) { create_list(:lesson_with_parts, 2) }
      subject { lessons.first.parts.last }

      it 'returns the lesson part #1 from the next lesson' do
        expect(subject.number).to be > 1
        expect(subject.next.number).to eq 1
        expect(subject.next.lesson).to eq lessons.last
      end
    end

    context 'when there is a gap in lesson part numbers' do
      let(:lesson) { create(:lesson) }
      let(:lesson_parts) { [1, 3].map { |n| create(:lesson_part, number: n, lesson: lesson) } }
      subject { lesson_parts.first }

      it 'returns nil if the gap is next' do
        expect(subject.next).to be nil
        lesson2 = create(:lesson_part, number: 2, lesson: lesson)
        expect(subject.next).to eq lesson2
      end
    end

    context 'when there is a gap in lesson numbers' do
      let(:lessons) { [1, 3].map { |n| create(:lesson_with_parts, number: n) } }
      subject { lessons.first.parts.last }

      it 'returns nil if the gap is next' do
        expect(subject.next).to be_nil
      end
    end

    context 'when there is a gap in lesson part numbers' do
      let(:lessons) { [create(:lesson), create(:lesson_with_parts)] }
      let(:lesson_parts) { [1, 3].map { |n| create(:lesson_part, number: n, lesson: lessons.first) } }
      subject { lesson_parts.first }

      it 'returns nil if the gap is next' do
        expect(subject.next).to be_nil
      end
    end

    context 'when there are 100 lessons with three parts each' do
      let(:lessons) { create_list(:lesson_with_parts, 100, parts_count: 3) }
      let(:first) { lessons.first.parts.first }
      let(:last) { lessons.last.parts.last }

      it 'enables iteration from the first to last lesson part' do
        expect((100 * 3 - 1).times.reduce(first) { |lesson_part| lesson_part.next }).to eq(last)
      end
    end
  end

  describe '.initial' do
    let!(:lesson) do
      FactoryBot.rewind_sequences
      create(:lesson_with_parts)
    end

    it 'returns Lesson 1, Part 1' do
      expect(described_class.initial).to eq lesson.parts.find_by(number: 1)
      expect(described_class.initial.lesson.number).to eq 1
    end
  end
end
