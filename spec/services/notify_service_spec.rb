require 'rails_helper'

RSpec.describe NotifyService do
  subject(:service) { described_class.new(api_key: 'SOME VALID KEY') }

  let(:template_id) { '5f06ec42-a1e2-44b7-a8d0-239f2b893fe9' }
  let(:email) { 'test@test.com' }
  let(:client) { instance_spy(Notifications::Client) }
  let(:response) {
    service.send_email(
      email_address: email,
      template_id: template_id
    )
  }

  describe '#send_email' do
    context 'when the NOTIFY_API_KEY is missing' do
      subject(:service) { described_class.new(api_key: nil) }

      it 'returns the error message accordingly' do
        expect {
          service.send_email(email_address: email, template_id: template_id)
        }.to raise_error(described_class::NotifyAPIError)
      end
    end

    context 'with personalised data' do
      let(:response) { instance_double(Notifications::Client::ResponseNotification) }
      let(:options) {
        {
          url: 'google.com'
        }
      }

      it 'passes the correct payload to the Notify service' do
        allow(Notifications::Client).to receive(:new).and_return(client)
        allow(client).to receive(:send_email).and_return(response)

        service.send_email(
          email_address: email,
          template_id: template_id,
          options: options
        )

        expect(client).to have_received(:send_email).with(
          email_address: email,
          template_id: template_id,
          personalisation: {
            url: 'google.com'
          }
        )
      end
    end

    context 'without personalised data' do
      let(:response) { instance_double(Notifications::Client::ResponseNotification) }

      it 'passes the correct payload to the Notify service' do
        allow(Notifications::Client).to receive(:new).and_return(client)
        allow(client).to receive(:send_email).and_return(response)

        service.send_email(
          email_address: email,
          template_id: template_id
        )

        expect(client).to have_received(:send_email).with(
          email_address: email,
          template_id: template_id,
          personalisation: {}
        )
      end
    end
  end

  describe '#health_check' do
    context 'with successful API call' do
      let(:id) { SecureRandom.uuid }
      let(:response) { instance_double(Notifications::Client::ResponseNotification, id: id) }

      before do
        allow(Notifications::Client).to receive(:new).and_return(client)
        allow(client).to receive(:send_email).and_return(response)
      end

      it 'passes the correct payload to the Notify service' do
        service.health_check

        expect(client).to have_received(:send_email).with(
          email_address: described_class::HEALTH_CHECK_EMAIL,
          template_id: described_class::HEALTH_CHECK_TEMPLATE_ID
        )
      end

      it 'returns fake sent message id' do
        expect(service.health_check).to eq(id)
      end
    end

    context 'with failed API call' do
      let(:response) { instance_double(Net::HTTPResponse, code: 500, body: 'FUBAR') }

      before do
        allow(Notifications::Client).to receive(:new).and_return(client)
        allow(client).to receive(:send_email).and_raise(Notifications::Client::RequestError, response)
      end

      it 'throws exception' do
        expect {
          service.health_check
        }.to raise_error(Notifications::Client::RequestError)
      end
    end
  end
end
