# Represents students in the app
class Student < ApplicationRecord
  belongs_to :lesson_part, optional: true
  delegate :lesson, to: :lesson_part, allow_nil: true
end
