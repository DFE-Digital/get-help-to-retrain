require 'rails_helper'

RSpec.describe JobVacanciesHelper do
  describe '#titleize_without_downcasing' do
    it 'does not change a string that is already titleized' do
      expect(
        helper.titleize_without_downcasing('PCSO offer')
      ).to eq('PCSO offer')
    end

    it 'does titleize a string that is not already' do
      expect(
        helper.titleize_without_downcasing('community officer')
      ).to eq('Community officer')
    end
  end
end
