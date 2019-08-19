RSpec.shared_examples 'a person' do
  describe 'name' do
    it 'is required by database constraints' do
      expect { described_class.create!(name: 'test').update_column(:name, nil) }
        .to raise_error ActiveRecord::NotNullViolation
    end

    it 'validates presence' do
      expect(described_class.create(name: nil)).to be_invalid
      expect(described_class.create(name: '')).to be_invalid
    end

    it 'validates the alphabetic contents' do
      expect(described_class.create(name: 'Jim')).to be_valid
      expect(described_class.create(name: 'Jim Jones')).to be_valid
      expect(described_class.create(name: '1234Jim')).not_to be_valid
    end

    it 'validates the length' do
      expect(described_class.create(name: 'x' * 200)).to be_valid
      expect(described_class.create(name: 'x' * 201)).to be_invalid
    end

    it 'allows reading and writing a name' do
      student = described_class.create!(name: 'Jim')
      expect { student.name = 'Jim Jones' }
        .to change { student.name }
        .from('Jim')
        .to('Jim Jones')
    end
  end
end
