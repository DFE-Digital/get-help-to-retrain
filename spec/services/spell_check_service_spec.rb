require 'rails_helper'

RSpec.describe SpellCheckService do
  subject(:service) { described_class.new(api_key: 'test') }

  let(:request_headers) {
    {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Ocp-Apim-Subscription-Key' => 'test'
    }
  }

  let(:response_body) {
    {
      '_type': 'SpellCheck',
      'flaggedTokens': []
    }.to_json
  }

  let(:search_term) { 'hallo wrld' }
  let(:status) { 200 }

  before do
    allow(Rails.configuration).to receive(:bing_spell_check_api_endpoint).and_return('https://s111-bingspellcheck.cognitiveservices.azure.com/bing/v7.0/spellcheck')
  end

  describe '.call' do
    before do
      stub_request(:get, Rails.configuration.bing_spell_check_api_endpoint)
        .with(headers: request_headers,
              query: URI.encode_www_form(mkt: 'en-gb', mode: 'spell', text: search_term))
        .to_return(body: response_body, status: status)
    end

    context 'when there is correction available' do
      let(:response_body) {
        {
          '_type': 'SpellCheck',
          'flaggedTokens': [
            {
              'offset': 0,
              'token': 'hallo',
              'type': 'UnknownToken',
              'suggestions': [
                {
                  'suggestion': 'hello',
                  'score': 1.0
                }
              ]
            },
            {
              'offset': 6,
              'token': 'wrld',
              'type': 'UnknownToken',
              'suggestions': [
                {
                  'suggestion': 'world',
                  'score': 1.0
                }
              ]
            }
          ]
        }.to_json
      }

      it 'returns the corrected keyword(s)' do
        expect(service.scan(search_term: search_term)).to eq('hello world')
      end
    end

    context 'when there is correction available with duplicated values' do
      let(:response_body) {
        {
          '_type': 'SpellCheck',
          'flaggedTokens': [
            {
              'offset': 0,
              'token': 'therpy',
              'type': 'UnknownToken',
              'suggestions': [
                {
                  'suggestion': 'therapy',
                  'score': 1.0
                }
              ]
            },
            {
              'offset': 6,
              'token': 'therpy',
              'type': 'UnknownToken',
              'suggestions': [
                {
                  'suggestion': 'therapy',
                  'score': 1.0
                }
              ]
            }
          ]
        }.to_json
      }

      let(:search_term) { 'therpy therpy' }

      it 'returns the corrected keyword(s)' do
        expect(service.scan(search_term: search_term)).to eq('therapy')
      end
    end

    context 'when there is only 1 correction available' do
      let(:response_body) {
        {
          '_type': 'SpellCheck',
          'flaggedTokens': [
            {
              'offset': 0,
              'token': 'papr',
              'type': 'UnknownToken',
              'suggestions': [
                {
                  'suggestion': 'paper',
                  'score': 1.0
                }
              ]
            }
          ]
        }.to_json
      }

      let(:search_term) { 'papr stuff' }

      it 'returns the corrected keyword(s)' do
        expect(service.scan(search_term: search_term)).to eq('paper stuff')
      end
    end

    context 'when there is at least 2/3 corrections order is preserved' do
      let(:response_body) {
        {
          '_type': 'SpellCheck',
          'flaggedTokens': [
            {
              'offset': 0,
              'token': 'papr',
              'type': 'UnknownToken',
              'suggestions': [
                {
                  'suggestion': 'paper',
                  'score': 1.0
                }
              ]
            },
            {
              'offset': 6,
              'token': 'makr',
              'type': 'UnknownToken',
              'suggestions': [
                {
                  'suggestion': 'maker',
                  'score': 1.0
                }
              ]
            }
          ]
        }.to_json
      }

      let(:search_term) { 'papr stuff makr' }

      it 'returns the corrected keyword(s)' do
        expect(service.scan(search_term: search_term)).to eq('paper stuff maker')
      end
    end

    context 'when there are partial corrections for both upcase/downcase terms' do
      let(:response_body) {
        {
          '_type': 'SpellCheck',
          'flaggedTokens': [
            {
              'offset': 0,
              'token': 'papr',
              'type': 'UnknownToken',
              'suggestions': [
                {
                  'suggestion': 'paper',
                  'score': 1.0
                }
              ]
            }
          ]
        }.to_json
      }

      let(:search_term) { 'Paper papr' }

      it 'returns the corrected keyword(s) with no duplicates' do
        expect(service.scan(search_term: search_term)).to eq('paper')
      end
    end

    context 'when there is no correction available' do
      it 'returns nil' do
        expect(service.scan(search_term: search_term)).to be nil
      end
    end

    context 'when no search term is passed' do
      it 'returns nil' do
        expect(service.scan(search_term: nil)).to be nil
      end
    end

    context 'when response status code is HTTP_BAD_REQUEST_CODE: 400' do
      let(:response_body) {
        {
          '_type': 'ErrorResponse',
          'instrumentation': {},
          'errors': [
            {
              'code': 'InvalidRequest',
              'subCode': 'ParameterMissing',
              'message': 'Required parameter is missing.',
              'parameter': 'text'
            }
          ]
        }.to_json
      }

      let(:status) { 400 }

      let(:expected_error_message) {
        "Code: 400, response: #{response_body}"
      }

      it 'raises SpellCheckService::SpellCheckServiceError' do
        expect {
          service.scan(search_term: search_term)
        }.to raise_error(described_class::SpellCheckServiceError, expected_error_message)
      end
    end

    context 'when response status code is HTTP_UNAUTHORIZED_CODE: 401' do
      let(:response_body) {
        {
          'error': {
            'statusCode': 401,
            'message': 'Access denied due to invalid subscription key. Make sure you are subscribed to an API you are trying to call and provide the right key.'
          }
        }.to_json
      }

      let(:status) { 401 }

      let(:expected_error_message) {
        "Code: 401, response: #{response_body}"
      }

      it 'raises SpellCheckService::SpellCheckServiceError' do
        expect {
          service.scan(search_term: search_term)
        }.to raise_error(described_class::SpellCheckServiceError, expected_error_message)
      end
    end

    context 'when response status code is HTTP_FORBIDDEN_CODE: 403' do
      let(:response_body) {
        {
          'error': {
            'statusCode': 403,
            'message': 'Out of call volume quota. Quota will be replenished in 2.12 days.'
          }
        }.to_json
      }

      let(:status) { 403 }

      let(:expected_error_message) {
        "Code: 403, response: #{response_body}"
      }

      it 'raises SpellCheckService::SpellCheckServiceError' do
        expect {
          service.scan(search_term: search_term)
        }.to raise_error(described_class::SpellCheckServiceError, expected_error_message)
      end
    end

    context 'when response status code is HTTP_RATE_LIMIT_EXCEEDED_CODE: 429' do
      let(:response_body) {
        {
          'error': {
            'statusCode': 429,
            'message': 'Out of call volume quota. Quota will be replenished in 2.12 days.'
          }
        }.to_json
      }

      let(:status) { 429 }

      let(:expected_error_message) {
        "Code: 429, response: #{response_body}"
      }

      it 'raises SpellCheckService::SpellCheckServiceError' do
        expect {
          service.scan(search_term: search_term)
        }.to raise_error(described_class::SpellCheckServiceError, expected_error_message)
      end
    end
  end

  context 'when the API key is missing' do
    subject(:service) { described_class.new(api_key: nil) }

    it 'returns nil' do
      expect(service.scan(search_term: search_term)).to be nil
    end
  end

  context 'when the API endpoint is missing' do
    subject(:service) { described_class.new(api_key: nil) }

    it 'returns nil' do
      allow(Rails.configuration).to receive(:bing_spell_check_api_endpoint).and_return(nil)

      expect(service.scan(search_term: search_term)).to be nil
    end
  end
end
