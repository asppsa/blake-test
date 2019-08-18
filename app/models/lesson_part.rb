# Each {Lesson} is divided up into numbered parts, represented by LessonPart
# objects.  Each LessonPart has a {#number} which mustbe unique within the
# lesson.
#
# LessonParts also have an association to {Student}s, as at any one time, some
# number of students will have progressed to each lesson part.
class LessonPart < ApplicationRecord
  # @!attribute [r] id
  #   @return [Integer] the lesson part ID.  This uniquely identifies the
  #     lesson part regardless of what lesson it belongs to.

  # @!attribute number
  #   @return [Integer] the lesson part number.  This must be unique to each
  #     lesson part in a lesson.

  # @!attribute lesson
  #   @return [Lesson] the lesson that this lesson part belongs to.  This
  #     cannot be `nil`.
  belongs_to :lesson

  # @!attribute students
  #   @return [<Student>] a collection of {Student}s presently progressed to
  #     this lesson part.
  has_many :students, dependent: :nullify

  # Returns a string displaying the lesson part as "Lesson x, Part y"
  #
  # @return [String]
  def display_number
    "Lesson #{lesson.number}, Part #{number}"
  end
end
