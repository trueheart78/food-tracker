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

  describe '.to_sym' do
    context 'when the test environment' do
      before { set_env :APP_ENV, :test }

      it 'is the symbol version' do
        expect(described_class.to_sym).to eq :test
      end
    end
  end

  describe '.twitter_handle?' do
    context 'when the twitter_creator has content' do
      before { set_env :TWITTER_CREATOR, :username }

      it 'is true' do
        expect(described_class.twitter_handle?).to eq true
      end
    end

    context 'when the twitter_creator is empty' do
      before { set_env :TWITTER_CREATOR, '' }

      it 'is true' do
        expect(described_class.twitter_handle?).to eq false
      end
    end
  end

  describe '.twitter_creator' do
    context 'when the environment variable is unset' do
      before { set_env :TWITTER_CREATOR, nil }

      it 'returns an empty string' do
        expect(described_class.twitter_creator).to eq ''
      end
    end

    context 'when the environment variable is empty' do
      before { set_env :TWITTER_CREATOR, '' }

      it 'returns an empty string' do
        expect(described_class.twitter_creator).to eq ''
      end
    end

    context 'when the environment variable does not have a leading @' do
      before { set_env :TWITTER_CREATOR, :username }

      it 'returns the username with a leading @' do
        expect(described_class.twitter_creator).to eq '@username'
      end
    end

    context 'when the environment variable has a leading @' do
      before { set_env :TWITTER_CREATOR, '@username' }

      it 'returns the username' do
        expect(described_class.twitter_creator).to eq '@username'
      end
    end
  end

  describe '.twitter_site' do
    before { set_env :TWITTER_CREATOR, twitter_creator }

    let(:twitter_creator) { '@username' }

    context 'when the environment variable is unset' do
      before { set_env :TWITTER_SITE, nil }

      it 'returns the twitter_creator' do
        expect(described_class.twitter_site).to eq twitter_creator
      end
    end

    context 'when the environment variable is empty' do
      before { set_env :TWITTER_SITE, '' }

      it 'returns the twitter_creator' do
        expect(described_class.twitter_site).to eq twitter_creator
      end
    end

    context 'when the environment variable does not have a leading @' do
      before { set_env :TWITTER_SITE, :username }

      it 'returns the username with a leading @' do
        expect(described_class.twitter_site).to eq '@username'
      end
    end

    context 'when the environment variable has a leading @' do
      before { set_env :TWITTER_SITE, '@username' }

      it 'returns the username' do
        expect(described_class.twitter_site).to eq '@username'
      end
    end
  end

  describe '.url' do
    let(:request) { dummy_request url: 'https://food-tracker.com' }

    it 'returns the request\'s base_url' do
      expect(described_class.url(request)).to eq request.base_url
    end
  end

  describe '.domain' do
    let(:request) { dummy_request url: url }
    let(:domain)  { 'food-tracker.com' }

    context 'with a secure protocol' do
      let(:url) { "https://#{domain}" }

      it 'returns the domain without the secure protocol' do
        expect(described_class.domain(request)).to eq domain
      end
    end

    context 'with an insecure protocol' do
      let(:url) { "http://#{domain}" }

      it 'returns the domain without the insecure protocol' do
        expect(described_class.domain(request)).to eq domain
      end
    end
  end

  describe '.force_ssl?' do
    context 'when in the production environment' do
      before { set_env :APP_ENV, :production }

      let(:request) { dummy_request url: '', ssl: ssl }

      context 'when SSL is enabled' do
        let(:ssl) { true }

        it 'returns false' do
          expect(described_class.force_ssl?(request)).to eq false
        end
      end

      context 'when SSL is not enabled' do
        let(:ssl) { false }

        it 'returns true' do
          expect(described_class.force_ssl?(request)).to eq true
        end
      end
    end

    context 'when not in the production environment' do
      before { set_env :APP_ENV, :test }

      let(:request) { dummy_request url: '', ssl: true }

      it 'returns false' do
        expect(described_class.force_ssl?(request)).to eq false
      end
    end
  end
end
