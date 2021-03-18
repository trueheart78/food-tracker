# frozen_string_literal: true

RSpec.describe DataLine, type: :model do
  subject(:data_line) { described_class.new string }

  describe '#valid?' do
    context 'when the string has content' do
      let(:string) { 'text' }

      it 'is valid' do
        expect(data_line).to be_valid
      end
    end

    context 'when the string has content' do
      context 'when the string is empty' do
        let(:string) { '' }

        it 'is invalid' do
          expect(data_line).to_not be_valid
        end
      end

      context 'when the string is nil' do
        let(:string) { nil }

        it 'is invalid' do
          expect(data_line).to_not be_valid
        end
      end
    end
  end
end
