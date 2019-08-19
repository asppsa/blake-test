# This models teachers in our app.
#
# A Teacher teaches zero or more {#students}.
class Teacher < ApplicationRecord
  include Person

  # @!attribute [r] id
  #   @return [Integer] the teacher ID.  This uniquely identifies the teacher.

  # @!attribute students
  #   @return [<Student>] a collection of {Student}s presently taught by this
  #     teacher.
  has_many :students, dependent: :nullify, inverse_of: :teacher
end
