require 'rails_helper'

RSpec.describe UrlParser do
  describe '#build_redirect_url_with' do
    it 'does nothing if host is different than current host' do
      parser = described_class.new('http://another-host.com/skills', 'myhost.com')

      expect(
        parser.build_redirect_url_with(
          param_name: 'email',
          param_value: 'test@test.test',
          anchor: 'email'
        )
      ). to be_nil
    end

    it 'add params to url as well as anchor' do
      parser = described_class.new('http://myhost.com/skills', 'myhost.com')

      expect(
        parser.build_redirect_url_with(
          param_name: 'email',
          param_value: 'test@test.test',
          anchor: 'email'
        )
      ). to eq(
        'http://myhost.com/skills?email=test%40test.test#email'
      )
    end

    it 'does not duplicate params' do
      parser = described_class.new('http://myhost.com/skills?email=another-test', 'myhost.com')

      expect(
        parser.build_redirect_url_with(
          param_name: 'email',
          param_value: 'test@test.test',
          anchor: 'email'
        )
      ). to eq(
        'http://myhost.com/skills?email=test%40test.test#email'
      )
    end

    it 'adds params to url safely with existing params' do
      parser = described_class.new('http://myhost.com/skills?some-params=test', 'myhost.com')

      expect(
        parser.build_redirect_url_with(
          param_name: 'email',
          param_value: 'test@test.test',
          anchor: 'email'
        )
      ). to eq(
        'http://myhost.com/skills?some-params=test&email=test%40test.test#email'
      )
    end
  end

  describe '#get_redirect_path' do
    it 'returns path if host is part of app' do
      referer = 'http://myhost.com/skills?job_profile_id=hitman'
      parser = described_class.new(referer, 'myhost.com')

      expect(parser.get_redirect_path). to eq('/skills?job_profile_id=hitman')
    end

    it 'does not return path if host is not part of app' do
      referer = 'http://not-my-app/dodgy-path'
      parser = described_class.new(referer, 'myhost.com')

      expect(parser.get_redirect_path). to be_nil
    end

    it 'does not return path if its part of urls to ignore' do
      referer = 'http://myhost.com/save-my-results'
      parser = described_class.new(referer, 'myhost.com')

      expect(parser.get_redirect_path(paths_to_ignore: ['/save-my-results'])). to be_nil
    end

    it 'does not return path if its part of urls to ignore and theres a query' do
      referer = 'http://myhost.com/save-my-results?some-query'
      parser = described_class.new(referer, 'myhost.com')

      expect(parser.get_redirect_path(paths_to_ignore: ['/save-my-results'])). to be_nil
    end
  end
end
