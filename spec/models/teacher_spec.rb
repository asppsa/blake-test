require 'rails_helper'
require_relative './person_helper.rb'

RSpec.describe Teacher, type: :model do
  it_behaves_like 'a person'
end
