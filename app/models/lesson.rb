class Lesson < ApplicationRecord
  has_many :parts, -> { order :number },
           class_name: 'LessonPart',
           dependent: :destroy,
           inverse_of: :lesson
end
