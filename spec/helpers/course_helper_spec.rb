require 'rails_helper'

RSpec.describe CourseHelper do
  describe '.format_date' do
    it 'returns a formatted start date' do
      expect(
        helper.format_date('2019-05-02T00:00:00Z', true)
      ).to eq('02 May 2019')
    end

    it 'returns a flexible start date if date is nil but marked as flexible' do
      expect(
        helper.format_date(nil, true)
      ).to eq('Flexible start date')
    end

    it 'returns contact provider if date is nil but marked as not flexible' do
      expect(
        helper.format_date(nil, false)
      ).to eq('Contact provider')
    end

    it 'returns nil when start date is invalid' do
      expect(
        helper.format_date('2019-99-99', true)
      ).to be_nil
    end
  end
end
