# frozen_string_literal: true

RSpec.describe Site, type: :model do
  let(:default_site) { described_class.new url: url, domain: domain }
  let(:url)          { 'https://www.food-tracker.com' }
  let(:domain)       { url.sub 'https://', '' }

  context 'when initialized' do
    subject(:site) { described_class.new url: url, domain: domain }

    it 'has the url' do
      expect(site.url).to eq url
    end

    it 'has the domain' do
      expect(site.domain).to eq domain
    end

    it 'has the icon' do
      expect(site.icon).to eq :hamburger
    end

    it 'has the default title' do
      expect(site.title).to eq 'Food, Pls?'
    end

    it 'has the correct description' do
      expect(site.description).to eq 'A personalized food tracker.'
    end

    it 'has the default style' do
      expect(site.style).to eq :default
    end

    it 'has the footer enabled' do
      expect(site.footer?).to eq true
    end
  end

  describe '#footer?' do
    subject(:footer) { default_site.footer? }

    context 'when first initialized' do
      it { is_expected.to eq true }
    end

    context 'when disabled' do
      before { default_site.disable_footer }

      it { is_expected.to eq false }
    end
  end

  describe '#png_url' do
    subject(:png_url) { default_site.png_url }

    it { is_expected.to eq "#{url}/images/hamburger.png" }
  end

  describe '#png' do
    subject(:png) { default_site.png }

    it { is_expected.to eq '/images/hamburger.png' }
  end

  describe '#gif' do
    subject(:gif) { default_site.gif }

    it { is_expected.to eq '/images/hamburger-rotating.gif' }
  end
end
