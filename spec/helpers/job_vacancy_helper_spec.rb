require 'rails_helper'

RSpec.describe JobVacancyHelper do
  describe '#map_current_page_from' do
    it 'maps current page modulus if not divisble by 5' do
      expect(helper.map_current_page_from('12')).to eq('2')
    end

    it 'maps pages divisble by 5 to 5' do
      expect(helper.map_current_page_from('10')).to eq('5')
    end

    it 'returns 1 if no page available' do
      expect(helper.map_current_page_from(nil)).to eq('1')
    end
  end
end
