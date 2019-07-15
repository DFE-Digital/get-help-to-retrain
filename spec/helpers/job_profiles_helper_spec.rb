require 'rails_helper'

RSpec.describe JobProfilesHelper do
  describe '.job_profile_breadcrumbs_for' do
    it 'returns categories breadcrumbs if referer path is a category' do
      params = { category: 1 }
      expect(helper.job_profile_breadcrumbs_for(params)).to eq(
        [t('breadcrumb.job_category'), category_path(1)]
      )
    end

    it 'returns explore occupations results breadcrumbs if referer path is a defined result' do
      params = { search: 'Developer' }
      expect(helper.job_profile_breadcrumbs_for(params)).to eq(
        [t('breadcrumb.search_results'), results_explore_occupations_path(name: 'Developer')]
      )
    end

    it 'defaults to empty explore occupations results' do
      expect(helper.job_profile_breadcrumbs_for({})).to eq(
        [t('breadcrumb.search_results'), results_explore_occupations_path]
      )
    end
  end
end
