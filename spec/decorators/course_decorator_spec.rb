require 'rails_helper'

RSpec.describe CourseDecorator do
  subject(:decorated_course) { described_class.new(course) }

  let(:course) {
    build_stubbed(
      :course,
      address_line_1: 'Flat 5',
      address_line_2: 'Street 1',
      town: 'Manchester',
      county: 'Great Manchester',
      postcode: '1DF 3HG'
    )
  }

  describe '#full_address' do
    it 'returns the full address block' do
      expect(decorated_course.full_address).to eq "Flat 5, Street 1<br>Manchester, Great Manchester<br>1DF 3HG"
    end
  end
end
