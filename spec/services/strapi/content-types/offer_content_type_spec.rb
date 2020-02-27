require 'rails_helper'

RSpec.describe Strapi::StrapiService do
  subject(:service) { described_class.new(authorization: 'Bearer test123') }

  let(:request_headers) {
    {
      'Content-Type' => 'application/json; charset=UTF-8',
      # 'Authorization' => 'Bearer test123'
    }
  }

  let(:response_body) {
    {
      :id => 1,
      :external_link_warning => "Selecting one of these links will take you to another website.",
      :created_at => "2020-02-26T15:53:03.863Z",
      :updated_at => "2020-02-26T15:53:03.863Z",
      :Standard => [
        {
          :id => 3,
          :description => "Some areas have local schemes that can offer you more ideas and opportunities.",
          :sub_description => "If you don't see anything listed below for your area, try calling the number below. The adviser may be able to point you to schemes in your area.",
          :body => "## Cambridge & Peterborough\n\nThe [Health and Care Sector Work Academy](https://cambridgeshirepeterborough-ca.gov.uk/about-us/programmes/skills/star-hub/health-and-care-sector-work-academy/)\n\n## Leeds\n\nInformation on changing careers from [Leeds City Region Local Enterprise Partnership](https://futuregoals.co.uk/)"
        }
      ],
      :Tel => [
        {
          :id => 2,
          :tel_number => "0800 051 0459",
          :tel_link => "tel:00448000510459",
          :tel_times => "Monday to Friday, 9am to 5pm"
        }
      ]
    }.to_json
  }

  let(:status) { 200 }

  describe 'offers' do
    before do
      stub_request(:get, Strapi::StrapiService::API_ENDPOINT + 'offers/1')
        .with(headers: request_headers)
        .to_return(body: response_body, status: status)
    end

    context 'when we ask for the offers link warning' do
      it 'returns correctly the correct text' do
        offer_content_type = Strapi::ContentTypes::OfferContentType.new(service)
        expect(offer_content_type.content['external_link_warning']).to eq('Selecting one of these links will take you to another website.')
      end
    end

    context 'when we ask for the offers standard content' do
      it 'returns correctly marked up content HTML' do
        offer_content_type = Strapi::ContentTypes::OfferContentType.new(service)
        expect(offer_content_type.content['standard']).to eq('Selecting one of these links will take you to another website.')
      end
    end
    context 'when we ask for the offers tel content' do
      it 'returns correctly marked up content HTML' do
        offer_content_type = Strapi::ContentTypes::OfferContentType.new(service)
        expect(offer_content_type.content['tel']).to eq('Selecting one of these links will take you to another website.')
      end
    end
  end
end
