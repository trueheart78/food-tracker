# frozen_string_literal: true

RSpec.describe DataLine, type: :model do
  subject(:data_line) { default_data_line }

  let(:default_data_line) { described_class.new string, location: location }
  let(:string)            { 'Orange Juice' }
  let(:location)          { 'Cupboard' }

  describe 'OUT_OF_STOCK_MARKER' do
    subject(:marker) { described_class::OUT_OF_STOCK_MARKER }

    it { is_expected.to eq '^oos^' }
  end

  describe 'EXPIRING_SOON_DAYS' do
    subject(:days) { described_class::EXPIRING_SOON_DAYS }

    it { is_expected.to eq 5 }
  end

  describe '#valid?' do
    context 'when the string has content' do
      let(:string) { 'text' }

      it { is_expected.to be_valid }
    end

    context 'when the string is empty' do
      let(:string) { '' }

      it { is_expected.to be_valid }
    end

    context 'when the string is nil' do
      let(:string) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#out_of_stock?' do
    context 'when the string does not have the marker' do
      let(:string) { 'text' }

      it { is_expected.not_to be_out_of_stock }
    end

    context 'when the string does have the marker' do
      let(:string) { 'text ^oos^' }

      it { is_expected.to be_out_of_stock }
    end
  end

  describe '#expiring?' do
    before { Timecop.freeze static_time }

    after  { Timecop.return }

    context 'with a single expiration date' do
      context 'when the expiration date has passed' do
        let(:string) { "test [#{yesterday}]" }

        it { is_expected.not_to be_expiring }
      end

      context 'when the expiration date matches the current date' do
        let(:string) { "test [#{today}]" }

        it { is_expected.not_to be_expiring }
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

      context 'when the expiration date is in five days' do
        let(:string) { "test [#{five_days_from_now}]" }

        it { is_expected.to be_expiring }
      end

      context 'when the expiration date is in six days' do
        let(:string) { "test [#{six_days_from_now}]" }

        it { is_expected.not_to be_expiring }
      end
    end

    context 'with multiple expiration dates' do
      context 'when the expiration dates have passed' do
        let(:string) { "test [#{yesterday}] [#{a_week_ago}]" }

        it { is_expected.not_to be_expiring }
      end

      context 'when an expiration date matches the current date' do
        let(:string) { "test [#{today}] [#{a_week_from_now}]" }

        it { is_expected.not_to be_expiring }
      end

      context 'when an expiration date is tomorrow' do
        let(:string) { "test [#{tomorrow}] [#{a_week_from_now}]" }

        it { is_expected.to be_expiring }
      end

      context 'when an expiration date is in two days' do
        let(:string) { "test [#{two_days_from_now}] [#{a_week_from_now}]" }

        it { is_expected.to be_expiring }
      end

      context 'when an expiration date is in three days' do
        let(:string) { "test [#{three_days_from_now}] [#{a_week_from_now}]" }

        it { is_expected.to be_expiring }
      end

      context 'when an expiration date is in four days' do
        let(:string) { "test [#{four_days_from_now}] [#{a_week_from_now}]" }

        it { is_expected.to be_expiring }
      end

      context 'when an expiration date is in five days' do
        let(:string) { "test [#{five_days_from_now}] [#{a_week_from_now}]" }

        it { is_expected.to be_expiring }
      end

      context 'when an expiration date is in size days' do
        let(:string) { "test [#{six_days_from_now}] [#{a_week_from_now}]" }

        it { is_expected.not_to be_expiring }
      end
    end
  end

  describe '#expired?' do
    before { Timecop.freeze static_time }

    after  { Timecop.return }

    context 'with a single expiration date' do
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

        it { is_expected.not_to be_expired }
      end
    end

    context 'with multiple expiration dates' do
      context 'when an expiration date has passed' do
        let(:string) { "test [#{yesterday}] [#{tomorrow}]" }

        it { is_expected.to be_expired }
      end

      context 'when an expiration date matches the current date' do
        let(:string) { "test [#{today}] [#{tomorrow}]" }

        it { is_expected.to be_expired }
      end

      context 'when the expiration dates are in the future' do
        let(:string) { "test [#{tomorrow}] [#{two_days_from_now}]" }

        it { is_expected.not_to be_expired }
      end
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
      let(:string) { 'text )|(]}][4/30/29^{' }

      it 'is expected to have errors' do
        expect(data_line.errors.count).to eq 8
      end
    end

    context 'when the expiration date is invalid' do
      let(:string) { 'text [13/33/29]' }

      it 'is expected to have an error' do
        expect(data_line.errors.count).to eq 1
      end

      it 'is expected to be a InvalidDate' do
        expect(data_line.errors.first.exception.class).to eq DataLine::InvalidDate
      end

      it 'is expected to be have the invalid date in the message' do
        expect(data_line.errors.first.exception.message).to eq 'Bad date found in [13/33/29]'
      end
    end

    context 'when the best by date is invalid' do
      let(:string) { 'text |13/33/29|' }

      it 'is expected to have an error' do
        expect(data_line.errors.count).to eq 1
      end

      it 'is expected to be a InvalidDate' do
        expect(data_line.errors.first.exception.class).to eq DataLine::InvalidDate
      end

      it 'is expected to be have the invalid date in the message' do
        expect(data_line.errors.first.exception.message).to eq 'Bad date found in |13/33/29|'
      end
    end

    context 'when the custom location is not supported' do
      let(:string) { 'text (bathroom)' }

      it 'is expected to have an error' do
        expect(data_line.errors.count).to eq 1
      end

      it 'is expected to be a InvalidCustomLocation' do
        expect(data_line.errors.first.exception.class).to eq DataLine::InvalidLocation
      end

      it 'is expected to be have the invalid location in the message' do
        expect(data_line.errors.first.exception.message).to eq 'Unsupported custom location found: bathroom'
      end
    end

    context 'when the default location is not supported' do
      let(:location) { 'moon' }

      it 'is expected to have an error' do
        expect(data_line.errors.count).to eq 1
      end

      it 'is expected to be a InvalidCustomLocation' do
        expect(data_line.errors.first.exception.class).to eq DataLine::InvalidLocation
      end

      it 'is expected to be have the invalid location in the message' do
        expect(data_line.errors.first.exception.message).to eq "Unsupported default location found: #{location}"
      end
    end
  end

  describe '#name' do
    context 'when the out of stock marker is present' do
      let(:string) { 'text ^oos^' }

      it 'trims off the trailing whitespace' do
        expect(data_line.name).to eq 'text'
      end
    end

    context 'when there is an expiration date' do
      let(:string) { 'text [12/12/21]' }

      it 'trims off the trailing whitespace' do
        expect(data_line.name).to eq 'text'
      end
    end

    context 'when there is a best by date' do
      let(:string) { 'text |12/12/21|' }

      it 'trims off the trailing whitespace' do
        expect(data_line.name).to eq 'text'
      end
    end

    context 'when there is a brand' do
      let(:string) { 'text {Brand Name}' }

      it 'trims off the trailing whitespace' do
        expect(data_line.name).to eq 'text'
      end
    end

    context 'when there is a custom location' do
      let(:string) { 'text (freezer)' }

      it 'trims off the trailing whitespace' do
        expect(data_line.name).to eq 'text'
      end
    end

    context 'when there is one of everything' do
      let(:string) do
        'text (freezer) {Bart\'s Best} |2/13/29| [12/25/29] ^oos^ {Eating Alone For Days}'
      end

      it 'trims off the trailing whitespace' do
        expect(data_line.name).to eq 'text'
      end
    end
  end
end
