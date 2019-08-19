# This models students in our app.
#
# Each Student has a {#name}, and may have an associated {Lesson} and {LessonPart}
# that they have progressed to.  Students can have their progress set via the
# {#lesson_part} attribute (the {#lesson} is then delegated to {#lesson_part}).
class Student < ApplicationRecord
  include ::Person

  # @!attribute [r] id
  #   @return [Integer] the student ID.  This uniquely identifies the student.

  # @!attribute lesson_part
  #   @return [LessonPart, nil] the part of the {Lesson} that the student has
  #     progressed to.  This can be `nil` (and can be set to `nil`) to indicate
  #     that the student has made no progress.
  belongs_to :lesson_part, optional: true

  # @!attribute teacher
  #   @return [Teacher, nil] the student's {Teacher}.  This can be `nil` if the
  #     student does not have a teacher.
  belongs_to :teacher, optional: true

  # @return [Lesson, nil] the lesson that the student has progressed to.
  delegate :lesson, to: :lesson_part, allow_nil: true
end
