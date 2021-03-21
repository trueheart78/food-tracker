# frozen_string_literal: true

RSpec.describe DataLine, type: :model do
  subject(:data_line) { described_class.new string }

  describe '#valid?' do
    context 'when the string has content' do
      let(:string) { 'text' }

      it { is_expected.to be_valid }
    end

    context 'when the string has content' do
      context 'when the string is empty' do
        let(:string) { '' }

        it { is_expected.to_not be_valid }
      end

      context 'when the string is nil' do
        let(:string) { nil }

        it { is_expected.to_not be_valid }
      end
    end
  end

  describe '#out_of_stock?' do
    context 'when the string does not have the marker' do
      let(:string) { 'text' }

      it { is_expected.to_not be_out_of_stock }
    end

    context 'when the string does have the marker' do
      let(:string) { 'text ^oos^' }

      it { is_expected.to be_out_of_stock }
    end
  end

  describe '#expiring?' do
    before { Timecop.freeze static_time }
    after  { Timecop.return}

    context 'when the expiration date has passed' do
      let(:string) { "test [#{yesterday}]" }

      it { is_expected.to_not be_expiring }
    end

    context 'when the expiration date matches the current date' do
      let(:string) { "test [#{today}]" }

      it { is_expected.to_not be_expiring }
    end

    context 'when the expiration date is tomorrow' do
      let(:string) { "test [#{tomorrow}]" }

      it { is_expected.to be_expiring }
    end

    context 'when the expiration date is in two days' do
      let(:string) { "test [#{two_days_from_now}]" }

      it { is_expected.to be_expiring }
    end

    context 'when the expiration date is in three days' do
      let(:string) { "test [#{three_days_from_now}]" }

      it { is_expected.to be_expiring }
    end

    context 'when the expiration date is in four days' do
      let(:string) { "test [#{four_days_from_now}]" }

      it { is_expected.to be_expiring }
    end
  end

  describe '#expired?' do
    before { Timecop.freeze static_time }
    after  { Timecop.return}

    context 'when the expiration date has passed' do
      let(:string) { "test [#{yesterday}]" }

      it { is_expected.to be_expired }
    end

    context 'when the expiration date matches the current date' do
      let(:string) { "test [#{today}]" }

      it { is_expected.to be_expired }
    end

    context 'when the expiration date is in the future' do
      let(:string) { "test [#{tomorrow}]" }

      it { is_expected.to_not be_expired }
    end
  end

  describe '#errors?' do
    context 'when the string does not have an error' do
      let(:string) { 'text [4/30/29]' }

      it 'is expected to not have errors' do
        expect(data_line.errors?).to be_falsey
      end
    end

    context 'when the string does have errors' do
      let(:string) { 'text [[4/30/29])' }

      it 'is expected to have errors' do
        expect(data_line.errors?).to be_truthy
      end
    end
  end

  describe '#errors' do
    context 'when the string does not have an error' do
      let(:string) { 'text [4/30/29]' }

      it 'is expected to be empty' do
        expect(data_line.errors).to be_empty
      end
    end

    context 'when the string does have errors' do
      let(:string) { 'text |(]}][4/30/29)^{' }

      it 'is expected to have errors' do
        expect(data_line.errors.count).to eq 8
      end
    end
  end

  describe '#to_s' do
    context 'when the out of stock marker is present' do
      let(:string) { 'text ^oos^' }

      it 'trims off the trailing whitespace' do
        expect(data_line.to_s).to eq 'text'
      end
    end

    context 'when there is an expiration date' do
      let(:string) { 'text [12/12/21]' }

      it 'trims off the trailing whitespace' do
        expect(data_line.to_s).to eq 'text'
      end
    end

    context 'when there is a best by date' do
      let(:string) { 'text |12/12/21|' }

      it 'trims off the trailing whitespace' do
        expect(data_line.to_s).to eq 'text'
      end
    end

    context 'when there is a custom location' do
      let(:string) { 'text (freezer)' }

      it 'trims off the trailing whitespace' do
        expect(data_line.to_s).to eq 'text'
      end
    end
  end
end
