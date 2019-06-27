require 'rails_helper'

RSpec.describe JobProfilesHelper do
  describe '.job_profile_breadcrumbs_for' do
    it 'returns title for categories if referer path is a category' do
      expect(helper.job_profile_breadcrumbs_for('categories')).to eq(t('breadcrumb.job_category'))
    end

    it 'defaults to results page title' do
      expect(helper.job_profile_breadcrumbs_for('results')).to eq(t('breadcrumb.search_results'))
    end
  end
end
