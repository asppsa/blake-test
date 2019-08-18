json.extract! student, :id, :name, :created_at, :updated_at

if student.lesson_part
  json.lesson do
    json.partial! student.lesson, as: :lesson
  end

  json.lesson_part do
    json.partial! student.lesson_part, as: :lesson_part
  end
else
  json.lesson nil
  json.lesson_part nil
end
