FactoryBot.define do
  sequence(:teacher_name) { |n| "Teacher #{n.humanize}" }

  factory :teacher do
    name { generate(:teacher_name) }

    factory :teacher_with_students_count do
      transient do
        students_count { 20 }
      end

      factory :teacher_with_students do
        after :create do |teacher, evaluator|
          create_list(:student, evaluator.students_count, teacher: teacher)
        end
      end

      factory :teacher_with_students_and_lessons do
        after :create do |teacher, evaluator|
          create_list(:student_with_lesson, evaluator.students_count, teacher: teacher)
        end
      end
    end
  end

  sequence(:lesson_number, &:itself)
  sequence(:lesson_part_number, &:itself)

  factory :lesson_part do
    lesson
    number { generate(:lesson_part_number) }
  end

  factory :lesson do
    number { generate(:lesson_number) }

    factory :lesson_with_parts do
      transient do
        parts_count { 3 }
      end

      after :create do |lesson, evaluator|
        FactoryBot.sequence_by_name(:lesson_part_number).rewind
        create_list(:lesson_part, evaluator.parts_count, lesson: lesson)
      end
    end
  end

  sequence(:student_name) { |n| "Student #{n.humanize}" }

  factory :student do
    name { generate(:student_name) }

    factory :student_with_lesson do
      lesson_part
    end

    factory :student_with_teacher do
      teacher
    end

    factory :student_with_teacher_and_lesson do
      teacher
      lesson_part
    end
  end
end
