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

      it 'returns the price with 2 decimal places and the currency symbol attached' do
        expect(decorated_course_details.price).to eq '£210.00'
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

    context 'when a course url is missing the protocol' do
      let(:find_a_course_search_response) {
        {
          'courseURL' => 'www.test.com'
        }
      }

      it 'does attach the http protocol' do
        expect(
          decorated_course_details.course_url
        ).to eq('http://www.test.com')
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

    context 'when description is nil' do
      let(:course_description) { nil }

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
  end

  describe '#formatted_start_date' do
    context 'when start_date present' do
      it 'returns a formatted date' do
        expect(
          decorated_course_details.formatted_start_date
        ).to eq('01 Sep 2020')
      end
    end

    context 'when start date is nil, but flexible start date is true' do
      let(:find_a_course_search_response) do
        {
          'startDate' => nil,
          'flexibleStartDate' => true
        }
      end

      it 'returns Flexible start date' do
        expect(
          decorated_course_details.formatted_start_date
        ).to eq('Flexible start date')
      end
    end

    context 'when start date is nil, and flexible start date is false' do
      let(:find_a_course_search_response) do
        {
          'startDate' => nil,
          'flexibleStartDate' => false
        }
      end

      it 'returns Contact provider' do
        expect(
          decorated_course_details.formatted_start_date
        ).to eq('Contact provider')
      end
    end

    context 'when start date is invalid' do
      let(:find_a_course_search_response) do
        {
          'startDate' => '2019-99-99'
        }
      end

      it 'returns nil' do
        expect(
          decorated_course_details.formatted_start_date
        ).to be nil
      end
    end
  end

  describe '#course_qualification_level' do
    context 'when qualification_level is returned X from the NCS API' do
      let(:find_a_course_search_response) do
        {
          'qualification' => {
            'qualificationLevel' => 'X'
          }
        }
      end

      it 'returns Unknown' do
        expect(
          decorated_course_details.course_qualification_level
        ).to eq 'Unknown'
      end
    end

    context 'when qualification_level is returned E from the NCS API' do
      let(:find_a_course_search_response) do
        {
          'qualification' => {
            'qualificationLevel' => 'E'
          }
        }
      end

      it 'returns Entry Level' do
        expect(
          decorated_course_details.course_qualification_level
        ).to eq 'Entry Level'
      end
    end

    context 'when qualification_level is returned as a number from the NCS API' do
      let(:find_a_course_search_response) do
        {
          'qualification' => {
            'qualificationLevel' => '7'
          }
        }
      end

      it 'returns Level followed by the qualification level number' do
        expect(
          decorated_course_details.course_qualification_level
        ).to eq 'Level 7'
      end
    end
  end

  describe '#course_delivery_mode' do
    context 'when deliveryMode comes in as camelized' do
      let(:find_a_course_search_response) do
        {
          'deliveryMode' => 'ClassroomBased'
        }
      end

      it 'returns a transformed delivery_mode value' do
        expect(
          decorated_course_details.course_delivery_mode
        ).to eq 'Classroom based'
      end
    end

    context 'when deliveryMode in not camelized' do
      let(:find_a_course_search_response) do
        {
          'deliveryMode' => 'Online'
        }
      end

      it 'returns the same value' do
        expect(
          decorated_course_details.course_delivery_mode
        ).to eq 'Online'
      end
    end
  end

  describe '#course_study_mode' do
    context 'when studyMode comes in as camelized' do
      let(:find_a_course_search_response) do
        {
          'studyMode' => 'PartTime'
        }
      end

      it 'returns a transformed study_mode value' do
        expect(
          decorated_course_details.course_study_mode
        ).to eq 'Part-time'
      end
    end

    context 'when studyMode comes in not camelized' do
      let(:find_a_course_search_response) do
        {
          'studyMode' => 'Flexible'
        }
      end

      it 'returns the same value' do
        expect(
          decorated_course_details.course_study_mode
        ).to eq 'Flexible'
      end
    end

    context 'when studyMode comes in as Undefined' do
      let(:find_a_course_search_response) do
        {
          'studyMode' => 'Undefined'
        }
      end

      it 'returns nil' do
        expect(
          decorated_course_details.course_study_mode
        ).to be nil
      end
    end

    context 'when studyMode comes in as nil' do
      let(:find_a_course_search_response) do
        {
          'studyMode' => nil
        }
      end

      it 'returns nil' do
        expect(
          decorated_course_details.course_study_mode
        ).to be nil
      end
    end
  end
end
