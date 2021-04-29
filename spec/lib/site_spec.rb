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
      expect(site.icon).to eq :watermelon
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

    it { is_expected.to eq "#{url}/images/watermelon.png" }
  end

  describe '#png' do
    subject(:png) { default_site.png }

    it { is_expected.to eq '/images/watermelon.png' }

    it 'the image file exists' do
      png_path = File.join 'public', default_site.png

      expect(File.exist?(png_path)).to eq true
    end
  end

  describe '#gif' do
    subject(:gif) { default_site.gif }

    it { is_expected.to eq '/images/watermelon-rotating.gif' }

    it 'the image file exists' do
      gif_path = File.join 'public', default_site.gif

      expect(File.exist?(gif_path)).to eq true
    end
  end

  describe '#type' do
    subject(:type) { default_site.type }

    context 'when style is :in_stock' do
      before { default_site.style = :in_stock }

      it { is_expected.to eq 'in stock' }
    end

    context 'when style is :expiring' do
      before { default_site.style = :expiring }

      it { is_expected.to eq 'expiring' }
    end

    context 'when style is :out_of_stock' do
      before { default_site.style = :out_of_stock }

      it { is_expected.to eq 'out of stock' }
    end

    context 'when style is :all_items' do
      before { default_site.style = :all_items }

      it { is_expected.to eq 'all items' }
    end

    context 'when style is :environment_vars' do
      before { default_site.style = :environment_vars }

      it { is_expected.to eq 'environment vars' }
    end

    context 'when style is anything else' do
      before { default_site.style = :anything_else }

      it { is_expected.to eq 'anything else' }
    end
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

    context 'when style is :environment_vars' do
      before { default_site.style = :environment_vars }

      it { is_expected.to eq ['main.css', 'environment_vars.css'] }
    end

    context 'when style is anything else' do
      before { default_site.style = :anything_else }

      it { is_expected.to eq ['main.css', 'background-colors/default.css'] }
    end
  end

  describe '#touch_icon' do
    subject(:touch_icon) { default_site.touch_icon }

    context 'when style is :in_stock' do
      before { default_site.style = :in_stock }

      it { is_expected.to eq 'apple-touch-icon-in-stock.png' }

      it 'the icon file exists' do
        expiring_icon_path = File.join 'public', default_site.touch_icon

        expect(File.exist?(expiring_icon_path)).to eq true
      end
    end

    context 'when style is :expiring' do
      before { default_site.style = :expiring }

      it { is_expected.to eq 'apple-touch-icon-expiring.png' }

      it 'the icon file exists' do
        expiring_icon_path = File.join 'public', default_site.touch_icon

        expect(File.exist?(expiring_icon_path)).to eq true
      end
    end

    context 'when style is :out_of_stock' do
      before { default_site.style = :out_of_stock }

      it { is_expected.to eq 'apple-touch-icon-out-of-stock.png' }

      it 'the icon file exists' do
        out_of_stock_icon_path = File.join 'public', default_site.touch_icon

        expect(File.exist?(out_of_stock_icon_path)).to eq true
      end
    end

    context 'when style is :environment_vars' do
      before { default_site.style = :environment_vars }

      it { is_expected.to eq 'apple-touch-icon-environment-vars.png' }

      it 'the icon file exists' do
        out_of_stock_icon_path = File.join 'public', default_site.touch_icon

        expect(File.exist?(out_of_stock_icon_path)).to eq true
      end
    end

    context 'when style is anything else' do
      before { default_site.style = :anything_else }

      it { is_expected.to eq 'apple-touch-icon.png' }

      it 'the icon file exists' do
        default_icon_path = File.join 'public', default_site.touch_icon

        expect(File.exist?(default_icon_path)).to eq true
      end
    end
  end

  describe '#color' do
    subject(:color) { default_site.color }

    context 'when style is :in_stock' do
      before { default_site.style = :in_stock }

      it { is_expected.to include code: '#c4aead', name: 'silver pink' }
    end

    context 'when style is :expiring' do
      before { default_site.style = :expiring }

      it { is_expected.to include code: '#ffc0cb', name: 'pink' }
    end

    context 'when style is :out_of_stock' do
      before { default_site.style = :out_of_stock }

      it { is_expected.to include code: '#add8e6', name: 'light blue' }
    end

    context 'when style is :environment_vars' do
      before { default_site.style = :environment_vars }

      it { is_expected.to include code: '#ffffff', name: 'white' }
    end

    context 'when style is anything else' do
      before { default_site.style = :anything_else }

      it { is_expected.to include code: '#e9ffdb', name: 'nyanza' }
    end
  end

  describe '#header' do
    subject(:header) { default_site.header }

    context 'when style is :in_stock' do
      before { default_site.style = :in_stock }

      it { is_expected.to eq '🍉 In The Kitchen 🍉' }
    end

    context 'when style is :expiring' do
      before { default_site.style = :expiring }

      it { is_expected.to eq '📅 Expiring 📅' }
    end

    context 'when style is :out_of_stock' do
      before { default_site.style = :out_of_stock }

      it { is_expected.to eq '📝 Out of Stock 📝' }
    end

    context 'when style is :environment_vars' do
      before { default_site.style = :environment_vars }

      it { is_expected.to eq '📖 Environment Variables 📖' }
    end

    context 'when style is anything else' do
      before { default_site.style = :anything_else }

      it { is_expected.to be_empty }
    end
  end
end
