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

  it_behaves_like 'a list of editable people'
  include_examples :link_to_new

  it 'links to teachers\'s student reports' do
    assert_select 'table' do
      people.each do |person|
        assert_select 'td a[href=?]', path.call(person) + '/students'
      end
    end
  end
end
