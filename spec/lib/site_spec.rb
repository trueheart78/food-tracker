# frozen_string_literal: true

RSpec.describe Site, type: :model do
  subject(:site) { described_class.new url: url, domain: domain }

  let(:url)    { 'https://www.food-tracker.com' }
  let(:domain) { url.sub 'https://', '' }

  context 'when initialized' do
    it 'has the expected url' do
      expect(site.url).to eq url
    end

    it 'has the expected domain' do
      expect(site.domain).to eq domain
    end

    it 'has the expected icon' do
      expect(site.icon).to eq :hamburger
    end

    it 'has the expected description' do
      expect(site.description).to eq 'A personalized food tracker.'
    end
  end

  xit do
    binding.pry
  end
end
