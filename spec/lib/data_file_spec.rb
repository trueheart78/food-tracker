# frozen_string_literal: true

RSpec.describe DataFile, type: :model do
  subject(:data_file) { described_class.new file, type: type }

  let(:file) { fixture_path 'basic_valid.yaml' }
  let(:type) { :in_stock }

  describe '#valid?' do
    context 'when the file does exist' do
      let(:file) { fixture_path 'basic_valid.yaml' }

      it { is_expected.to be_valid }
    end

    context 'when the file does not exist' do
      let(:file) { fixture_path 'non_existing.yaml' }

      it { is_expected.not_to be_valid }
    end

    context 'when the type is not supported' do
      let(:type) { :unsupported_type }

      it { is_expected.not_to be_valid }
    end
  end

  describe '.load' do
    subject(:data_files) { described_class.load type: type }

    let(:type) { :out_of_stock }

    it 'does something' do
      # binding.pry
    end
  end
end
