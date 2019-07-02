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
      params = { explore_occupations_result: 'Developer' }
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

  describe '.alternative_names' do
    it 'returns a comma delimited list of alternative titles' do
      expect(helper.alternative_names(['Curator', 'records manager'])).to eq('Curator, records manager')
    end

    it 'returns a single name of alternative titles if its only one' do
      expect(helper.alternative_names(['Curator'])).to eq('Curator')
    end

    it 'returns nothing if no titles included' do
      expect(helper.alternative_names([])).to be_empty
    end
  end
end
