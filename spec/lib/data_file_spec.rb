# frozen_string_literal: true

require 'data_file'

RSpec.describe DataFile, type: :model do
  subject(:data_file) { described_class.new file }

  describe '#valid?' do
    context 'when the file does exist' do
      let(:file) { fixture_path 'existing_file.txt' }

      it 'is valid' do
        expect(data_file).to be_valid
      end
    end
    context 'when the file does not exist' do
      let(:file) { fixture_path 'non_existing_file.txt' }

      it 'is invalid' do
        expect(data_file).to_not be_valid
      end
    end
  end
end
