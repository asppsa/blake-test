# Represents students in the app
class Student < ApplicationRecord
  belongs_to :lesson_part, optional: true
  delegate :lesson, to: :lesson_part, allow_nil: true

  validates :name,
            presence: true,
            format: /\A[[:alpha:] -]+\z/,
            length: { maximum: 200 }

  # Make sure no trailing whitespace on names
  before_save { self.name = name.strip }
end
