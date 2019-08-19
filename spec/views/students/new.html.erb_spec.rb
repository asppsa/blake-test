require 'rails_helper'
require_relative './helper.rb'

RSpec.describe 'students/new', type: :view do
  let(:student) { build(:student) }
  let(:path) { students_path }

  before { assign(:student, student) }

  include_context :view_lessons_stub

  it_behaves_like 'a student form'
end
