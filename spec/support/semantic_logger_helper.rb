module SemanticLoggerHelper
  class RequestMock
    def ip
      '192.168.0.1'
    end

    def port
      3000
    end

    def remote_ip
      '192.168.0.2'
    end

    def server_port
      3000
    end

    def original_url
      'http://test.com/rspec?p=test'
    end

    def method
      'GET'
    end

    def referer
      'http://referer.test.com'
    end

    def request_id
      '7e72b918-44ba-4690-9e7c-5e178231ef9f'
    end

    def user_agent
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.5 ' \
        '(KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5'
    end

    def server_name
      'TestMachine'
    end

    def env
      {
        'SERVER_NAME' => 'test'
      }
    end
  end

  class UserMock
    def id
      12_345
    end

    def name
      'Mr Test'
    end

    def email
      'test@email.com'
    end
  end
end

RSpec.configure do |config|
  config.include SemanticLoggerHelper
end
