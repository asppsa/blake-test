require 'rails_helper'
require_relative '../person_helper.rb'

RSpec.describe 'teachers/edit', type: :view do
  let(:name) { 'teacher' }
  let(:teacher) { create(:teacher) }
  let(:path) { teacher_path(teacher) }

  before { assign(:teacher, teacher) }

  it_behaves_like 'a person form'
end
