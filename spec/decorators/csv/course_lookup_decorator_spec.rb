require 'rails_helper'

RSpec.describe Csv::CourseLookupDecorator do
  subject(:decorated_course_lookup) { described_class.new(course_lookup) }

  let(:course_lookup) {
    build_stubbed(
      :course_lookup,
      addressable: venue
    )
  }

  let(:venue) {
    build(
      :venue,
      address_line_1: 'Flat 5',
      address_line_2: 'Street 1',
      town: 'Manchester',
      county: 'Great Manchester',
      postcode: '1DF 3HG'
    )
  }

  describe '#full_address' do
    it 'returns the full address block' do
      expect(decorated_course_lookup.full_address).to eq 'Flat 5, Street 1<br>Manchester, Great Manchester<br>1DF 3HG'
    end

    context 'when town is missing' do
      let(:venue) {
        build_stubbed(
          :venue,
          address_line_1: 'Flat 5',
          address_line_2: 'Street 1',
          postcode: '1DF 3HG',
          town: nil,
          county: 'Great Manchester'
        )
      }

      it 'doesn not show the town in the full address block' do
        expect(decorated_course_lookup.full_address).to eq 'Flat 5, Street 1<br>Great Manchester<br>1DF 3HG'
      end
    end

    context 'when both town and county are missing' do
      let(:venue) {
        build_stubbed(
          :venue,
          address_line_1: 'Flat 5',
          address_line_2: 'Street 1',
          postcode: '1DF 3HG',
          town: nil,
          county: nil
        )
      }

      it 'does not show that address line in the full address block' do
        expect(decorated_course_lookup.full_address).to eq 'Flat 5, Street 1<br>1DF 3HG'
      end
    end

    context 'when address_2 is missing' do
      let(:venue) {
        build_stubbed(
          :venue,
          address_line_1: 'Flat 5',
          address_line_2: nil,
          postcode: '1DF 3HG',
          town: nil,
          county: nil
        )
      }

      it 'does not show address_2 in the full address block' do
        expect(decorated_course_lookup.full_address).to eq 'Flat 5<br>1DF 3HG'
      end
    end

    context 'when address_1 and address_2 are both missing' do
      let(:venue) {
        build_stubbed(
          :venue,
          address_line_1: nil,
          address_line_2: nil,
          postcode: '1DF 3HG',
          town: nil,
          county: nil
        )
      }

      it 'returns only the postcode in the full address block' do
        expect(decorated_course_lookup.full_address).to eq '1DF 3HG'
      end
    end
  end
end
