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

  # Returns the next {LessonPart}, or `nil`.
  #
  # The next lesson part is defined as:
  #
  # 1. the {LessonPart} with {#number} equal to the present number plus one; or
  #    if that does not exist, and there are no further lesson parts in this
  #    lesson ...
  # 2. the {LessonPart} with {#number} equal to 1 in {Lesson#next} (if that
  #    exists).
  #
  # It will return `nil` if either there is no next lesson, or if the next
  # lesson does not have a lesson part with number = 1.  Therefore, if there
  # are "gaps" in the lessons (e.g. there are lessons 2 and 4, but no lesson
  # 3), this method will return `nil`.  Also, if there is a "gap" in the lesson
  # part numbers of the current lesson (e.g. in lesson 1 there are parts 2 and
  # 4), this method will also return `nil`.
  #
  # @example Getting Lesson 1, Part 2
  #   LessonPart.initial.next #=> #<LessonPart number=2>
  #
  # @example Getting Lesson 2, Part 1
  #   Lesson.first.parts.last.next #=> #<LessonPart number=1>
  #
  # @example Retuns `nil` when there are no more lesson parts
  #   Lesson.last.parts.last.next #=> nil
  #
  # @return [LessonPart, nil]
  def next
    lesson.parts.find_by(number: number + 1) || begin
      # This ensures that a gap between lesson parts
      return nil if lesson.parts.find_by('number > ?', number)

      # Check that there is a next lesson, and if there is return lesson part
      # 1, if it exists.
      next_lesson = lesson.next
      next_lesson && next_lesson.parts.find_by(number: 1)
    end
  end

  # Returns Lesson 1, Part 1.
  #
  # This is where {Student}s start on their progression.  This will return
  # `nil` if the initial lesson part does not exist.
  #
  # @return [LessonPart, nil]
  def self.initial
    LessonPart.joins(:lesson).merge(Lesson.where(number: 1)).find_by(number: 1)
  end
end
