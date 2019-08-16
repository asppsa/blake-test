# A Lesson is composed of some number of {LessonPart}s.
class Lesson < ApplicationRecord
  has_many :parts, -> { order :number },
           class_name: 'LessonPart',
           dependent: :destroy,
           inverse_of: :lesson

  def display_number
    "Lesson #{number}"
  end
end
