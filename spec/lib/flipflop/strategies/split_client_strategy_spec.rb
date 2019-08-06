require 'rails_helper'

RSpec.describe Flipflop::Strategies::SplitClientStrategy do
  subject(:strategy) { described_class.new(api_key: api_key, path: path) }

  # Use localhost mode for splitclient SDK. This loads features from yml
  # file rather than making API calls which is faster for testing
  let(:api_key) { 'localhost' }
  let(:path) { Rails.root.join('spec', 'fixtures', 'files', 'split.yml') }

  describe '.enabled?' do
    it 'is true for enabled feature' do
      expect(strategy.enabled?(:foo)).to be true
    end

    it 'is false for disabled feature' do
      expect(strategy.enabled?(:bar)).to be false
    end

    it 'is false for unknown feature' do
      expect(strategy.enabled?(:baz)).to be false
    end

    it 'defaults to false for all features when we cannot connect to SplitIO' do
      allow(SplitIoClient::SplitFactoryBuilder).to receive(:build).and_raise(Faraday::ConnectionFailed)
      expect(strategy.enabled?(:foo)).to be(false)
    end

    context 'with invalid configuration' do
      let(:api_key) { 'eXaMpLeApIkEy' }

      it 'defaults to false for all features' do
        expect(strategy.enabled?(:foo)).to be(false)
      end
    end
  end
end
