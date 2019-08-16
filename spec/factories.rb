FactoryBot.define do
  sequence(:lesson_number, &:itself)
  sequence(:lesson_part_number, &:itself)

  factory :lesson_part do
    number { generate(:lesson_part_number) }
  end

  factory :lesson do
    number { generate(:lesson_number) }

    factory :lesson_with_parts do
      transient do
        parts_count { 3 }
      end

      after :create do |lesson, evaluator|
        create_list(:lesson_part, evaluator.parts_count, lesson: lesson)
      end
    end
  end
end
