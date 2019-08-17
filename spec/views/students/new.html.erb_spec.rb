require 'rails_helper'
require_relative './helper.rb'

RSpec.describe 'students/new', type: :view do
  before :each do
    assign(:student, Student.new(name: 'MyString'))
  end

  include_context :view_lessons_stub
  let(:path) { students_path }

  it_behaves_like 'a student form'
end
