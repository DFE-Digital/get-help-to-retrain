require 'rails_helper'

RSpec.describe CourseDetails do
  subject(:course_details) {
    described_class.new(find_a_course_search_response)
  }

  let(:find_a_course_search_response) do
    JSON.parse(
      Rails.root.join('spec', 'fixtures', 'files', 'find_a_course_details_response.json').read
    )
  end

  describe '#qualification_name' do
    context 'when both keys exist in the body' do
      it 'returns the correct qualification name' do
        expect(
          course_details.qualification_name
        ).to eq 'GCE A Level in Further Mathematics'
      end
    end

    context 'when qualification key is missing' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(course_details.qualification_name).to be nil
      end
    end

    context 'when qualification key is present but learnAimRefTitle is missing' do
      let(:find_a_course_search_response) {
        {
          'qualification' => {}
        }
      }

      it 'returns nil' do
        expect(course_details.qualification_name).to be nil
      end
    end
  end

  describe '#qualification_level' do
    context 'when both keys exist in the body' do
      it 'returns the correct qualification level' do
        expect(
          course_details.qualification_level
        ).to eq '3'
      end
    end

    context 'when qualification key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.qualification_level
        ).to be nil
      end
    end

    context 'when qualification key is present but qualificationLevel is missing' do
      let(:find_a_course_search_response) {
        {
          'qualification' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.qualification_level
        ).to be nil
      end
    end
  end

  describe '#study_mode' do
    context 'when studyMode key is present in the body' do
      it 'returns the study mode value' do
        expect(
          course_details.study_mode
        ).to eq 'FullTime'
      end
    end

    context 'when studyMode key is missing' do
      let(:find_a_course_search_response) {
        {}
      }

      it 'returns nil' do
        expect(
          course_details.study_mode
        ).to be nil
      end
    end
  end

  describe '#attendance_pattern' do
    context 'when attendancePattern key is present in the body' do
      it 'returns the correct attendance pattern value' do
        expect(
          course_details.attendance_pattern
        ).to eq 'Daytime'
      end
    end

    context 'when attendancePattern key is missing' do
      let(:find_a_course_search_response) {
        {}
      }

      it 'returns nil' do
        expect(
          course_details.attendance_pattern
        ).to be nil
      end
    end
  end

  describe '#cost' do
    context 'when cost key is present in the body' do
      it 'returns the correct cost value' do
        expect(
          course_details.cost
        ).to eq 0.0
      end
    end

    context 'when cost key is missing' do
      let(:find_a_course_search_response) {
        {}
      }

      it 'returns nil' do
        expect(
          course_details.cost
        ).to be nil
      end
    end
  end

  describe '#start_date' do
    context 'when startDate key is present in the body' do
      it 'returns the correct cost value' do
        expect(
          course_details.start_date
        ).to eq '2020-09-01T00:00:00'
      end
    end

    context 'when startDate key is missing' do
      let(:find_a_course_search_response) {
        {}
      }

      it 'returns nil' do
        expect(
          course_details.start_date
        ).to be nil
      end
    end
  end

  describe '#description' do
    context 'when both keys exist in the body' do
      it 'returns the correct description' do
        expect(
          course_details.description
        ).to eq 'Very short description'
      end
    end

    context 'when course key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.description
        ).to be nil
      end
    end

    context 'when course key is present but courseDescription is missing' do
      let(:find_a_course_search_response) {
        {
          'course' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.description
        ).to be nil
      end
    end
  end

  describe '#provider_name' do
    context 'when both keys exist in the body' do
      it 'returns the correct provider name' do
        expect(
          course_details.provider_name
        ).to eq 'LONGBENTON HIGH SCHOOL'
      end
    end

    context 'when provider key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.provider_name
        ).to be nil
      end
    end

    context 'when provider key is present but providerName is missing' do
      let(:find_a_course_search_response) {
        {
          'provider' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.provider_name
        ).to be nil
      end
    end
  end

  describe '#provider_address_line_1' do
    context 'when both keys exist in the body' do
      it 'returns the correct provider address line 1' do
        expect(
          course_details.provider_address_line_1
        ).to eq 'Flat 6, Street 1'
      end
    end

    context 'when provider key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.provider_address_line_1
        ).to be nil
      end
    end

    context 'when provider key is present but addressLine1 is missing' do
      let(:find_a_course_search_response) {
        {
          'provider' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.provider_address_line_1
        ).to be nil
      end
    end
  end

  describe '#provider_address_line_2' do
    context 'when both keys exist in the body' do
      it 'returns the correct provider address line 1' do
        expect(
          course_details.provider_address_line_2
        ).to eq 'Foxton Road'
      end
    end

    context 'when provider key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.provider_address_line_2
        ).to be nil
      end
    end

    context 'when provider key is present but addressLine2 is missing' do
      let(:find_a_course_search_response) {
        {
          'provider' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.provider_address_line_2
        ).to be nil
      end
    end
  end

  describe '#provider_town' do
    context 'when both keys exist in the body' do
      it 'returns the correct provider town' do
        expect(
          course_details.provider_town
        ).to eq 'Newcastle Upon Tyne'
      end
    end

    context 'when provider key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.provider_town
        ).to be nil
      end
    end

    context 'when provider key is present but town is missing' do
      let(:find_a_course_search_response) {
        {
          'provider' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.provider_town
        ).to be nil
      end
    end
  end

  describe '#provider_postcode' do
    context 'when both keys exist in the body' do
      it 'returns the correct provider town' do
        expect(
          course_details.provider_postcode
        ).to eq 'NE12 8ER'
      end
    end

    context 'when provider key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.provider_postcode
        ).to be nil
      end
    end

    context 'when provider key is present but provider_postcode is missing' do
      let(:find_a_course_search_response) {
        {
          'provider' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.provider_postcode
        ).to be nil
      end
    end
  end

  describe '#provider_county' do
    context 'when both keys exist in the body' do
      it 'returns the correct provider town' do
        expect(
          course_details.provider_county
        ).to eq 'Yorkshire'
      end
    end

    context 'when provider key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.provider_county
        ).to be nil
      end
    end

    context 'when provider key is present but provider_county is missing' do
      let(:find_a_course_search_response) {
        {
          'provider' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.provider_county
        ).to be nil
      end
    end
  end

  describe '#provider_email' do
    context 'when both keys exist in the body' do
      it 'returns the correct provider email' do
        expect(
          course_details.provider_email
        ).to eq 'test@test.com'
      end
    end

    context 'when provider key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.provider_email
        ).to be nil
      end
    end

    context 'when provider key is present but provider_email is missing' do
      let(:find_a_course_search_response) {
        {
          'provider' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.provider_email
        ).to be nil
      end
    end
  end

  describe '#provider_phone' do
    context 'when both keys exist in the body' do
      it 'returns the correct provider email' do
        expect(
          course_details.provider_phone
        ).to eq '0191 218 9500'
      end
    end

    context 'when provider key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.provider_phone
        ).to be nil
      end
    end

    context 'when provider key is present but telephone is missing' do
      let(:find_a_course_search_response) {
        {
          'provider' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.provider_phone
        ).to be nil
      end
    end
  end

  describe '#provider_website' do
    context 'when both keys exist in the body' do
      it 'returns the correct provider website' do
        expect(
          course_details.provider_website
        ).to eq 'https://www.provider.com'
      end
    end

    context 'when provider key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.provider_website
        ).to be nil
      end
    end

    context 'when provider key is present but website is missing' do
      let(:find_a_course_search_response) {
        {
          'provider' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.provider_website
        ).to be nil
      end
    end
  end

  describe '#website' do
    context 'when the courseURL key exists in the body' do
      it 'returns the correct provider website' do
        expect(
          course_details.website
        ).to eq 'https://www.course.com'
      end
    end

    context 'when the courseURL key is missing' do
      let(:find_a_course_search_response) {
        {}
      }

      it 'returns nil' do
        expect(
          course_details.website
        ).to be nil
      end
    end
  end

  describe '#name' do
    context 'when the courseName key exists in the body' do
      it 'returns the correct course name value' do
        expect(
          course_details.name
        ).to eq 'GCE ADV Further Maths'
      end
    end

    context 'when the courseName key is missing' do
      let(:find_a_course_search_response) {
        {}
      }

      it 'returns nil' do
        expect(
          course_details.name
        ).to be nil
      end
    end
  end

  describe '#delivery_mode' do
    context 'when the deliveryMode key exists in the body' do
      it 'returns the correct delivery mode value' do
        expect(
          course_details.delivery_mode
        ).to eq 'ClassroomBased'
      end
    end

    context 'when the deliveryMode key is missing' do
      let(:find_a_course_search_response) {
        {}
      }

      it 'returns nil' do
        expect(
          course_details.delivery_mode
        ).to be nil
      end
    end
  end

  describe '#flexible_start_date' do
    context 'when the flexibleStartDate key exists in the body' do
      it 'returns the correct flexible start date value' do
        expect(
          course_details.flexible_start_date
        ).to be false
      end
    end

    context 'when the flexibleStartDate key is missing' do
      let(:find_a_course_search_response) {
        {}
      }

      it 'returns nil' do
        expect(
          course_details.flexible_start_date
        ).to be nil
      end
    end
  end

  describe '#venue_website' do
    context 'when both keys exist in the body' do
      it 'returns the correct venue website' do
        expect(
          course_details.venue_website
        ).to eq 'https://www.venue.com'
      end
    end

    context 'when venue key is missing from the body' do
      let(:find_a_course_search_response) { {} }

      it 'returns nil' do
        expect(
          course_details.venue_website
        ).to be nil
      end
    end

    context 'when venue key is present but website is missing' do
      let(:find_a_course_search_response) {
        {
          'venue' => {}
        }
      }

      it 'returns nil' do
        expect(
          course_details.venue_website
        ).to be nil
      end
    end
  end
end
