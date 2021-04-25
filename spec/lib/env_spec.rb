# frozen_string_literal: true

RSpec.describe Env do
  after { restore_env }

  describe '.production?' do
    context 'when the production environment' do
      before { set_env :APP_ENV, :production }

      it 'is true' do
        expect(described_class).to be_production
      end
    end

    context 'when not the production environment' do
      before { set_env :APP_ENV, :test }

      it 'is false' do
        expect(described_class).not_to be_production
      end
    end
  end

  describe '.development?' do
    context 'when the development environment' do
      before { set_env :APP_ENV, :development }

      it 'is true' do
        expect(described_class).to be_development
      end
    end

    context 'when not the development environment' do
      before { set_env :APP_ENV, :test }

      it 'is false' do
        expect(described_class).not_to be_development
      end
    end
  end

  describe '.test?' do
    context 'when the test environment' do
      before { set_env :APP_ENV, :test }

      it 'is true' do
        expect(described_class).to be_test
      end
    end

    context 'when not the test environment' do
      before { set_env :APP_ENV, :development }

      it 'is false' do
        expect(described_class).not_to be_test
      end
    end
  end
end
