require 'rails_helper'

RSpec.describe CourseDetailsDecorator do
  subject(:decorated_course_details) {
    described_class.new(course_details)
  }

  let(:find_a_course_search_response) do
    JSON.parse(
      Rails.root.join('spec', 'fixtures', 'files', 'find_a_course_details_response.json').read
    )
  end

  let(:course_details) do
    CourseDetails.new(find_a_course_search_response)
  end

  describe '#provider_full_address' do
    it 'returns the full address block' do
      expect(
        decorated_course_details.provider_full_address
      ).to eq 'Flat 6, Street 1, Foxton Road<br>Newcastle Upon Tyne, Yorkshire<br>NE12 8ER'
    end

    context 'when town is missing' do
      let(:find_a_course_search_response) do
        {
          'provider' => {
            'addressLine1' => 'Flat 6, Street 1',
            'addressLine2' => 'Foxton Road',
            'town' => nil,
            'postcode' => 'NE12 8ER',
            'county' => 'Yorkshire'
          }
        }
      end

      it 'does not show the town in the full address block' do
        expect(
          decorated_course_details.provider_full_address
        ).to eq 'Flat 6, Street 1, Foxton Road<br>Yorkshire<br>NE12 8ER'
      end
    end

    context 'when both town and county are missing' do
      let(:find_a_course_search_response) do
        {
          'provider' => {
            'addressLine1' => 'Flat 6, Street 1',
            'addressLine2' => 'Foxton Road',
            'town' => nil,
            'postcode' => 'NE12 8ER',
            'county' => nil
          }
        }
      end

      it 'does not show that address line in the full address block' do
        expect(
          decorated_course_details.provider_full_address
        ).to eq 'Flat 6, Street 1, Foxton Road<br>NE12 8ER'
      end
    end

    context 'when address_2 is missing' do
      let(:find_a_course_search_response) do
        {
          'provider' => {
            'addressLine1' => 'Flat 6, Street 1',
            'addressLine2' => nil,
            'town' => nil,
            'postcode' => 'NE12 8ER',
            'county' => nil
          }
        }
      end

      it 'does not show address_2 in the full address block' do
        expect(decorated_course_details.provider_full_address).to eq 'Flat 6, Street 1<br>NE12 8ER'
      end
    end

    context 'when address_1 and address_2 are both missing' do
      let(:find_a_course_search_response) do
        {
          'provider' => {
            'addressLine1' => nil,
            'addressLine2' => nil,
            'town' => nil,
            'postcode' => 'NE12 8ER',
            'county' => nil
          }
        }
      end

      it 'returns only the postcode in the full address block' do
        expect(decorated_course_details.provider_full_address).to eq 'NE12 8ER'
      end
    end
  end

  describe '#course_price' do
    context 'when the course cost is nil' do
      let(:find_a_course_search_response) do
        {
          'cost' => nil
        }
      end

      it 'returns nil' do
        expect(decorated_course_details.price).to be nil
      end
    end

    context 'when the course cost is 0' do
      let(:find_a_course_search_response) do
        {
          'cost' => 0.0
        }
      end

      it 'returns Free' do
        expect(decorated_course_details.price).to eq 'Free'
      end
    end

    context 'when the course cost is non zero' do
      let(:find_a_course_search_response) do
        {
          'cost' => 210.0
        }
      end

      it 'returns the price with the currency symbol attached' do
        expect(decorated_course_details.price).to eq '£210.0'
      end
    end
  end

  describe '#course_url' do
    context 'when course url is present' do
      let(:find_a_course_search_response) do
        {
          'provider' => {
            'website' => 'https://provider.com'
          },
          'venue' => {
            'website' => 'https://venue.com'
          },
          'courseURL' => 'https://course.com'
        }
      end

      it 'returns the course url value' do
        expect(decorated_course_details.course_url).to eq('https://course.com')
      end
    end

    context 'when courseURL is nil, but provider website is present' do
      let(:find_a_course_search_response) do
        {
          'provider' => {
            'website' => 'https://provider.com'
          },
          'venue' => {
            'website' => 'https://venue.com'
          },
          'courseURL' => nil
        }
      end

      it 'returns the provider website value' do
        expect(decorated_course_details.course_url).to eq('https://provider.com')
      end
    end

    context 'when course urls are missing but provider url is present' do
      let(:find_a_course_search_response) do
        {
          'provider' => {
            'website' => nil
          },
          'venue' => {
            'website' => 'https://venue.com'
          },
          'courseURL' => nil
        }
      end

      it 'returns the venue website value' do
        expect(decorated_course_details.course_url).to eq('https://venue.com')
      end
    end

    context 'when courseURL, provider website is missing, and venue website is missing' do
      let(:find_a_course_search_response) do
        {
          'provider' => {
            'website' => nil
          },
          'venue' => {
            'website' => nil
          },
          'courseURL' => nil
        }
      end

      it 'returns nil' do
        expect(decorated_course_details.course_url).to be nil
      end
    end
  end

  describe '#course_description' do
    context 'when description is less than 15 chars' do
      let(:course_description) {
        'small.'
      }

      let(:find_a_course_search_response) do
        {
          'course' => {
            'courseDescription' => course_description
          }
        }
      end

      it 'returns nil' do
        expect(decorated_course_details.course_description).to be nil
      end
    end

    context 'when description is more than 15 chars' do
      it 'returns the actual description' do
        expect(
          decorated_course_details.course_description
        ).to eq('Very short description')
      end
    end
  end
end
