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

    context 'when qualification_level is outside the 1..8 range' do
      let(:find_a_course_search_response) do
        {
          'qualification' => {
            'qualificationLevel' => '99'
          }
        }
      end

      it 'returns nil' do
        expect(
          decorated_course_details.course_qualification_level
        ).to eq '99'
      end
    end

    context 'when qualification_level is not a documented value' do
      let(:find_a_course_search_response) do
        {
          'qualification' => {
            'qualificationLevel' => '99XY'
          }
        }
      end

      it 'returns the actual value' do
        expect(
          decorated_course_details.course_qualification_level
        ).to eq '99XY'
      end
    end

    context 'when qualification_level is nil' do
      let(:find_a_course_search_response) do
        {
          'qualification' => nil
        }
      end

      it 'returns nil' do
        expect(
          decorated_course_details.course_qualification_level
        ).to be nil
      end
    end
  end

  describe '#course_delivery_mode' do
    context 'when deliveryMode is ClassroomBased' do
      let(:find_a_course_search_response) do
        {
          'deliveryMode' => 'ClassroomBased'
        }
      end

      it 'returns Classroom based' do
        expect(
          decorated_course_details.course_delivery_mode
        ).to eq 'Classroom based'
      end
    end

    context 'when deliveryMode is WorkBased' do
      let(:find_a_course_search_response) do
        {
          'deliveryMode' => 'WorkBased'
        }
      end

      it 'returns Work based' do
        expect(
          decorated_course_details.course_delivery_mode
        ).to eq 'Work based'
      end
    end

    context 'when deliveryMode is Online' do
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

    context 'when deliveryMode is an undocumented value' do
      let(:find_a_course_search_response) do
        {
          'deliveryMode' => 'Something not documented'
        }
      end

      it 'returns nil' do
        expect(
          decorated_course_details.course_delivery_mode
        ).to eq 'Something not documented'
      end
    end

    context 'when deliveryMode is nil' do
      let(:find_a_course_search_response) do
        {
          'deliveryMode' => nil
        }
      end

      it 'returns nil' do
        expect(
          decorated_course_details.course_delivery_mode
        ).to be nil
      end
    end
  end

  describe '#course_study_mode' do
    context 'when studyMode is PartTime' do
      let(:find_a_course_search_response) do
        {
          'studyMode' => 'PartTime'
        }
      end

      it 'returns Part-time' do
        expect(
          decorated_course_details.course_study_mode
        ).to eq 'Part-time'
      end
    end

    context 'when studyMode is FullTime' do
      let(:find_a_course_search_response) do
        {
          'studyMode' => 'FullTime'
        }
      end

      it 'returns Full-time' do
        expect(
          decorated_course_details.course_study_mode
        ).to eq 'Full-time'
      end
    end

    context 'when studyMode is Flexible' do
      let(:find_a_course_search_response) do
        {
          'studyMode' => 'Flexible'
        }
      end

      it 'returns Flexible' do
        expect(
          decorated_course_details.course_study_mode
        ).to eq 'Flexible'
      end
    end

    context 'when studyMode is an undocumented value' do
      let(:find_a_course_search_response) do
        {
          'studyMode' => 'Some weird value'
        }
      end

      it 'returns nil' do
        expect(
          decorated_course_details.course_study_mode
        ).to eq 'Some weird value'
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
