require 'rails_helper'

RSpec.describe Csv::OpportunityDecorator do
  subject(:decorated_opportunity) { described_class.new(opportunity) }

  let(:course) { create(:csv_course, provider: provider) }
  let(:venue) { create(:venue, provider: provider) }
  let(:provider) {
    create(
      :provider,
      address_line_1: 'Flat 6',
      address_line_2: 'Street 2',
      town: 'Manchester',
      county: 'Great Manchester',
      postcode: '5DF 3HG'
    )
  }
  let(:opportunity) { create(:opportunity, course: course, venue: venue, end_date: '2020-01-01', price: nil) }

  describe '#provider_full_address' do
    it 'returns the full address block' do
      expect(decorated_opportunity.provider_full_address).to eq 'Flat 6, Street 2<br>Manchester, Great Manchester<br>5DF 3HG'
    end

    context 'when town is missing' do
      let(:provider) {
        create(
          :provider,
          address_line_1: 'Flat 5',
          address_line_2: 'Street 1',
          postcode: '1DF 3HG',
          town: nil,
          county: 'Great Manchester'
        )
      }

      it 'does not show the town in the full address block' do
        expect(decorated_opportunity.provider_full_address).to eq 'Flat 5, Street 1<br>Great Manchester<br>1DF 3HG'
      end
    end

    context 'when both town and county are missing' do
      let(:provider) {
        create(
          :provider,
          address_line_1: 'Flat 5',
          address_line_2: 'Street 1',
          postcode: '1DF 3HG',
          town: nil,
          county: nil
        )
      }

      it 'does not show that address line in the full address block' do
        expect(decorated_opportunity.provider_full_address).to eq 'Flat 5, Street 1<br>1DF 3HG'
      end
    end

    context 'when address_2 is missing' do
      let(:provider) {
        create(
          :provider,
          address_line_1: 'Flat 5',
          address_line_2: nil,
          postcode: '1DF 3HG',
          town: nil,
          county: nil
        )
      }

      it 'does not show address_2 in the full address block' do
        expect(decorated_opportunity.provider_full_address).to eq 'Flat 5<br>1DF 3HG'
      end
    end

    context 'when address_1 and address_2 are both missing' do
      let(:provider) {
        create(
          :provider,
          address_line_1: nil,
          address_line_2: nil,
          postcode: '1DF 3HG',
          town: nil,
          county: nil
        )
      }

      it 'returns only the postcode in the full address block' do
        expect(decorated_opportunity.provider_full_address).to eq '1DF 3HG'
      end
    end
  end

  describe '#course_start_date' do
    it 'returns nil if there are no start dates available' do
      expect(decorated_opportunity.course_start_date).to be nil
    end

    it 'returns Different start dates if there are multiple start dates available' do
      create_list(:opportunity_start_date, 2, opportunity: opportunity)

      expect(decorated_opportunity.course_start_date).to eq 'Various start dates'
    end

    it 'returns the course start date formatted as %d %b %Y if present' do
      create(:opportunity_start_date, opportunity: opportunity, start_date: '2020-01-01')

      expect(decorated_opportunity.course_start_date).to eq('01 Jan 2020')
    end
  end

  describe '#course_price' do
    it 'returns nil if the price is nil' do
      expect(decorated_opportunity.course_price).to be nil
    end

    it 'returns Free if the price course is 0.0' do
      opportunity = create(:opportunity, course: course, venue: venue, price: 0.0)
      decorated_opportunity = described_class.new(opportunity)

      expect(decorated_opportunity.course_price).to eq 'Free'
    end

    it 'returns the price if present and non zero' do
      opportunity = create(:opportunity, course: course, venue: venue, price: 210.0)
      decorated_opportunity = described_class.new(opportunity)

      expect(decorated_opportunity.course_price).to eq('£210.0')
    end
  end

  describe '#course_url' do
    context 'when course booking_url is present' do
      let(:course) { create(:csv_course, booking_url: 'http://course_booking.com') }

      it 'returns the booking_url value' do
        expect(decorated_opportunity.course_url).to eq('http://course_booking.com')
      end
    end

    context 'when course booking_url is nil, but course url is present' do
      let(:course) {
        create(
          :csv_course,
          url: 'http://course_booking.com',
          booking_url: nil
        )
      }

      it 'returns the url value' do
        expect(decorated_opportunity.course_url).to eq('http://course_booking.com')
      end
    end

    context 'when course urls are missing but provider url is present' do
      let(:course) {
        create(
          :csv_course,
          provider: provider,
          url: nil,
          booking_url: nil
        )
      }

      let(:provider) {
        create(
          :provider,
          url: 'http://provider.com'
        )
      }

      it 'returns the provider url value' do
        expect(decorated_opportunity.course_url).to eq('http://provider.com')
      end
    end

    context 'when course urls are missing, provider url is missing, but venue url is present' do
      let(:course) {
        create(
          :csv_course,
          provider: provider,
          url: nil,
          booking_url: nil
        )
      }

      let(:provider) {
        create(
          :provider,
          url: nil
        )
      }

      let(:venue) {
        create(
          :venue,
          provider: provider,
          url: 'http://venue.com'
        )
      }

      it 'returns the venue url value' do
        expect(decorated_opportunity.course_url).to eq('http://venue.com')
      end
    end

    context 'when course urls are missing, provider url is missing, and venue url is missing' do
      let(:course) {
        create(
          :csv_course,
          provider: provider,
          url: nil,
          booking_url: nil
        )
      }

      let(:provider) {
        create(
          :provider,
          url: nil
        )
      }

      let(:venue) {
        create(
          :venue,
          provider: provider,
          url: nil
        )
      }

      it 'returns nil' do
        expect(decorated_opportunity.course_url).to be nil
      end
    end
  end

  describe '#course_description' do
    context 'when description is less than 15 chars' do
      let(:course) {
        create(
          :csv_course,
          provider: provider,
          description: 'Too small'
        )
      }

      it 'returns nil' do
        expect(decorated_opportunity.course_description).to be nil
      end
    end

    context 'when description is more than 15 chars' do
      it 'returns the actual description' do
        expect(decorated_opportunity.course_description).to eq(course.description)
      end
    end
  end
end
