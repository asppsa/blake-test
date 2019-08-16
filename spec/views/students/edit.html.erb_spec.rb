require 'rails_helper'
require_relative './helper.rb'

RSpec.describe 'students/edit', type: :view do
  let!(:student) { assign(:student, Student.create!(name: 'MyString')) }
  include_context :view_lessons_stub
  let(:path) { student_path(student) }

  it_behaves_like 'a student form'
end
