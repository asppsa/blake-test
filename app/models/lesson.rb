# Lesson objects model lessons.  They have a {#number}, and some number of
# {LessonPart}.
class Lesson < ApplicationRecord
  # @!attribute [r] id
  #   @return [Integer] the lesson ID

  # @!attribute number
  #   @return [Integer] the lesson number. This must be unique to each lesson.

  # @!attribute parts
  #   @return [<LessonPart>] a collection of the {LessonPart} objects that
  #     belong to this lesson.
  has_many :parts, -> { order :number },
           class_name: 'LessonPart',
           dependent: :destroy,
           inverse_of: :lesson

  # Returns a string for displaying the lesson number as "Lesson x".
  #
  # @return [String]
  def display_number
    "Lesson #{number}"
  end

  # Returns the next {Lesson}, or `nil`.
  #
  # The next lesson is defined as the one with the next number (i.e. current
  # number plus 1), so if there's a "gap" (e.g. lesson numbers 1, 2, 4), `nil`
  # will be returned instead.
  #
  # @example Getting lesson 2
  #   Lesson.first.next #=> #<Lesson number=2>
  #
  # @return [Lesson, nil]
  def next
    Lesson.find_by(number: number + 1)
  end
end
