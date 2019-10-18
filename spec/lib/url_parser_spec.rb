require 'rails_helper'

RSpec.describe UrlParser do
  describe '#get_redirect_path' do
    it 'returns path if host is part of app' do
      referer = 'http://myhost.com/skills?job_profile_id=hitman'
      parser = described_class.new(referer, 'myhost.com')

      expect(parser.get_redirect_path).to eq('/skills?job_profile_id=hitman')
    end

    it 'does not return path if host is not part of app' do
      referer = 'http://not-my-app/dodgy-path'
      parser = described_class.new(referer, 'myhost.com')

      expect(parser.get_redirect_path).to be_nil
    end

    it 'does not return path if its part of urls to ignore' do
      referer = 'http://myhost.com/save-my-results'
      parser = described_class.new(referer, 'myhost.com')

      expect(parser.get_redirect_path(paths_to_ignore: ['/save-my-results'])).to be_nil
    end

    it 'does not return path if its part of urls to ignore and theres a query' do
      referer = 'http://myhost.com/save-my-results?some-query'
      parser = described_class.new(referer, 'myhost.com')

      expect(parser.get_redirect_path(paths_to_ignore: ['/save-my-results'])).to be_nil
    end

    it 'returns nothing if no url passed' do
      parser = described_class.new(nil, 'myhost.com')

      expect(parser.get_redirect_path(paths_to_ignore: ['/save-my-results'])).to be_nil
    end
  end
end
