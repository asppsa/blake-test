# This models students in our app.
#
# Each Student has a {#name} and may also have a {Teacher}.  Students can
# progress through {Lesson}s and {LessonPart}s.  This progress is recorded via
# the {#lesson_part} attribute (the {#lesson} is then delegated to
# {#lesson_part}).
class Student < ApplicationRecord
  include Person

  # This is raised when {#advance_lesson!} fails
  class AdvanceError < RuntimeError; end

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

  # This progresses the Student's {#lesson_part} to the next one in the series.
  #
  # The {LessonPart} to progress to is determined according to the following
  # business logic:
  #
  # - if the student has no current lesson, set to {LessonPart.initial};
  # - if there is a {LessonPart#next} lesson part, set to that;
  # - otherwise, there is no next lesson; raise {Student::AdvanceError}.
  #
  # This logic is performed in a transaction with a write lock on this record.
  #
  # @raise [Student::AdvanceError] Raised if there was no {LessonPart} to
  #   advance to.
  # @return [LessonPart] The new {LessonPart}.
  def advance_lesson!
    with_lock do
      next_lesson_part = lesson_part ? lesson_part.next : LessonPart.initial
      raise Student::AdvanceError, 'No LessonPart to advance to' unless next_lesson_part

      update!(lesson_part: next_lesson_part)
      next_lesson_part
    end
  end
end
