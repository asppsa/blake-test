RSpec.shared_examples 'a list of people' do
  it 'displays people\'s names' do
    assert_select 'table' do
      people.each do |person|
        assert_select 'td', text: person.name
      end
    end
  end
end

RSpec.shared_examples 'a list of editable people' do
  include_examples 'a list of people'

  it 'links to people\'s edit pages' do
    assert_select 'table' do
      people.each do |person|
        assert_select 'td a[href=?]', path.call(person) + '/edit'
      end
    end
  end
end

RSpec.shared_examples :link_to_new do
  it 'displays a link to #new' do
    assert_select 'a[href=?]', path.call(:new)
  end
end

RSpec.shared_examples 'a person form' do
  before { render }

  it 'posts to the correct place' do
    assert_select 'form[action=?][method=?]', path, 'post'
  end

  it 'displays a name input' do
    assert_select 'input[name=?]', name + '[name]'
  end
end
