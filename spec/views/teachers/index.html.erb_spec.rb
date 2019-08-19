require 'rails_helper'
require_relative '../person_helper.rb'

RSpec.describe 'teachers/index', type: :view do
  let(:teachers) { create_list(:teacher, 10) }
  let(:people) { teachers }
  let(:path) { method(:teacher_path) }

  before(:each) do
    assign(:teachers, teachers)
    render
  end

  it_behaves_like 'a list of people'
end
