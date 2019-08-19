require 'rails_helper'
require_relative '../person_helper.rb'

RSpec.describe 'teachers/new', type: :view do
  let(:name) { 'teacher' }
  let(:teacher) { build(:teacher) }
  let(:path) { teachers_path }

  before { assign(:teacher, teacher) }

  it_behaves_like 'a person form'
end
