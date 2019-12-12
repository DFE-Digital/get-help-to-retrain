require 'rails_helper'

RSpec.describe SemanticLogger::Formatters::DataDog do
  describe 'DataDog' do
    let(:log) do
      log = SemanticLogger::Log.new('DataDogTest', :fatal)
      log.time = Time.utc(2018, 1, 1, 8, 0, 0)
      log.thread_name = 'Runner P0123'
      log.message = 'Message test'
      log.named_tags = { request: SemanticLoggerHelper::RequestMock.new, user: SemanticLoggerHelper::UserMock.new }
      log.payload = { sql: 'SELECT *' }
      log
    end

    let(:set_standard_error) do
      raise StandardError, 'BOOM'
    rescue StandardError => e
      e.set_backtrace(['backtrace'])
      log.exception = e
    end

    before { set_standard_error }

    it 'correctly formats message' do
      message = described_class.new.call(log, nil)
      expect(JSON.parse(message)).to eql(
        'level' => 'crit',
        'message' => 'Message test',
        'logger' => {
          'method_name' => 'DataDogTest',
          'name' => 'SemanticLogger',
          'thread_name' => 'Runner P0123'
        },
        'error' => {
          'stack' => 'backtrace',
          'message' => 'BOOM',
          'kind' => 'StandardError'
        },
        'network' => {
          'client' => {
            'ip' => '192.168.0.1',
            'port' => 3000
          },
          'destination' => {
            'ip' => '192.168.0.2',
            'port' => 3000
          }
        },
        'db' => {
          'statement' => 'SELECT *'
        },
        'http' => {
          'method' => 'GET',
          'referer' => 'http://referer.test.com',
          'request_id' => '7e72b918-44ba-4690-9e7c-5e178231ef9f',
          'url' => 'http://test.com/rspec?p=test',
          'url_details' => {
            'host' => 'test.com',
            'path' => '/rspec',
            'port' => 80,
            'queryString' => 'p=test',
            'scheme' => 'http'
          },
          'useragent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8)' \
                         ' AppleWebKit/536.5 (KHTML, like Gecko) ' \
                         'Chrome/19.0.1084.56 Safari/536.5',
          'useragent_details' => {
            'browser' => {
              'family' => 'AppleWebKit/536.5 (KHTML, like Gecko) Chrome'
            },
            'device' => {
              'family' => 'Macintosh'
            },
            'os' => {
              'family' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8)'
            }
          }
        },
        'usr' => {
          'id' => 12_345,
          'name' => 'Mr Test',
          'email' => 'test@email.com'
        },
        'syslog' => {
          'hostname' => 'test',
          'appname' => 'GetHelpToRetrain',
          'severity' => 'crit',
          'timestamp' => '1514793600000',
          'env' => 'test'
        }
      )
    end
  end
end
