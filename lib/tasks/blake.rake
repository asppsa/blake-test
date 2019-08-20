namespace :blake do
  desc 'Add two additional lesson parts to the first fifty lessons'
  task part4: :environment do
    raise 'This can only be performed if there are three parts to each lesson' \
      unless LessonPart.where('number > 3').empty?

    LessonPart.create!(Lesson.where('number <= 50').flat_map do |lesson|
      [4, 5].map { |n| { number: n, lesson: lesson } }
    end)
  end
end
