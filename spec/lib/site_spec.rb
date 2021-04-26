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

  describe '#stylesheets' do
    subject(:stylesheets) { default_site.stylesheets }

    context 'when style is :in_stock' do
      before { default_site.style = :in_stock }

      it { is_expected.to eq ['main.css', 'background-colors/in_stock.css'] }
    end

    context 'when style is :expiring' do
      before { default_site.style = :expiring }

      it { is_expected.to eq ['main.css', 'background-colors/expiring.css'] }
    end

    context 'when style is :out_of_stock' do
      before { default_site.style = :out_of_stock }

      it { is_expected.to eq ['main.css', 'background-colors/out_of_stock.css'] }
    end

    context 'when style is :all_items' do
      before { default_site.style = :all_items }

      it { is_expected.to eq ['main.css', 'background-colors/all_items.css'] }
    end

    context 'when style is :environment_vars' do
      before { default_site.style = :environment_vars }

      it { is_expected.to eq ['main.css', 'environment_vars.css'] }
    end

    context 'when style is anything else' do
      before { default_site.style = :anything_else }

      it { is_expected.to eq ['main.css', 'background-colors/default.css'] }
    end
  end

  describe '#touch_icons' do
    subject(:touch_icons) { default_site.touch_icons }

    context 'when style is :expiring' do
      before { default_site.style = :expiring }

      it { is_expected.to include default: 'apple-touch-icon-expiring.png', precomposed: 'apple-touch-icon-procomposed-expiring.png' }
    end

    context 'when style is :out_of_stock' do
      before { default_site.style = :out_of_stock }

      it { is_expected.to include default: 'apple-touch-icon-out-of-stock.png', precomposed: 'apple-touch-icon-procomposed-out-of-stock.png' }
    end

    context 'when style is anything else' do
      before { default_site.style = :anything_else }

      it { is_expected.to include default: 'apple-touch-icon.png', precomposed: 'apple-touch-icon-procomposed.png' }
    end
  end

  describe '#color' do
    subject(:color) { default_site.color }

    context 'when style is :in_stock' do
      before { default_site.style = :in_stock }

      it { is_expected.to eq '#ffdb57' }
    end

    context 'when style is :expiring' do
      before { default_site.style = :expiring }

      it { is_expected.to eq '#ffc0cb' }
    end

    context 'when style is :out_of_stock' do
      before { default_site.style = :out_of_stock }

      it { is_expected.to eq '#add8e6' }
    end

    context 'when style is :all_items' do
      before { default_site.style = :all_items }

      it { is_expected.to eq '#e9ffdb' }
    end

    context 'when style is :environment_vars' do
      before { default_site.style = :environment_vars }

      it { is_expected.to eq '#ffffff' }
    end

    context 'when style is anything else' do
      before { default_site.style = :anything_else }

      it { is_expected.to eq '#ffdb58' }
    end
  end
end
