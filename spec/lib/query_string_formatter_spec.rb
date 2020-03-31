require 'rails_helper'

RSpec.describe QueryStringFormatter do
  describe '.normalize' do
    it 'converts characters into their compatibility characters' do
      expect(described_class.normalize('2⁵')).to eq('25')
    end

    it 'composes all characters into single code points' do
      expect(described_class.normalize('Ƶ̧̈')).to eq('Ƶ')
    end

    it 'removes any non alphanumeric characters from the string' do
      expect(described_class.normalize('<script> ("pwned!")123 </script>')).to eq('script pwned123 script')
    end
  end

  describe '.format' do
    it 'allows a word to become prefix query' do
      expect(described_class.format('Cook')).to eq('Cook:*')
    end

    it 'allows multiple words to become OR prefix queries' do
      expect(described_class.format('Cook Chef')).to eq('Cook:* | Chef:*')
    end

    it 'removes any extra spaces in a string' do
      expect(described_class.format(' Chef  Fish   Cook  ')).to eq('Chef:* | Fish:* | Cook:*')
    end
  end

  describe '.format_exact_match' do
    it 'returns search for exact word' do
      expect(described_class.format_exact_match('Cook')).to eq('Cook')
    end

    it 'allows multiple words to become AND query' do
      expect(described_class.format_exact_match('Cook Chef')).to eq('Cook & Chef')
    end

    it 'removes any extra spaces in a string' do
      expect(described_class.format_exact_match(' Chef  Fish   Cook  ')).to eq('Chef & Fish & Cook')
    end
  end
end
