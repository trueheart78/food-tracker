# frozen_string_literal: true

RSpec.describe DataFile, type: :model do
  subject(:data_file) { described_class.new file }

  describe '#valid?' do
    context 'when the file does exist' do
      let(:file) { fixture_path 'basic_valid.yaml' }

      it 'is valid' do
        expect(data_file).to be_valid
      end
    end

    context 'when the file does not exist' do
      let(:file) { fixture_path 'non_existing.yaml' }

      it 'is invalid' do
        expect(data_file).to_not be_valid
      end
    end
  end

  describe '.load' do
    subject(:data_files) { described_class.load type: type }
    let(:type) { :out_of_stock }

    it 'does something' do

      binding.pry

    end
  end
end
