class LessonPart < ApplicationRecord
  belongs_to :lesson
  has_many :students, dependent: :nullify
end
