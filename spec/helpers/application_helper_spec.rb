require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '.page_title' do
    it 'returns correct translated page title' do
      helper.page_title(:home_index)
      expect(helper.content_for(:page_title)).to eq 'Get help to retrain - Home'
    end

    it 'warns of missing translations' do
      helper.page_title(:foo)
      expect(helper.content_for(:page_title)).to eq 'translation missing: en-GB.page_titles.foo'
    end
  end

  describe '.generate_breadcrumbs' do
    it 'returns current page list item' do
      expect(helper.generate_breadcrumbs('Current Page', [])).to match(/Current Page/)
    end

    it 'returns previous pages breadcrumbs' do
      expect(helper.generate_breadcrumbs('Current Page', [['Previous Page', '/']])).to match(/Previous Page/)
    end
  end
end
