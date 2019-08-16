# This creates 100 lessons with 3 parts to each one.
Rails.logger.info 'Creating 100 lessons, numbered 1..100 ...'
lessons = Lesson.create!((1..100).map { |number| { number: number } })
Rails.logger.info 'Creating 3 lesson parts per lesson, numbered 1..3 ...'
LessonPart.create!(lessons.flat_map do |lesson|
  (1..3).map { |number| { number: number, lesson: lesson } }
end)
