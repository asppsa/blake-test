# Each {Lesson} is divided up into numbered parts, represented by LessonPart
# objects.
class LessonPart < ApplicationRecord
  belongs_to :lesson
  has_many :students, dependent: :nullify

  def display_number
    "Lesson #{lesson.number}, Part #{number}"
  end
end
