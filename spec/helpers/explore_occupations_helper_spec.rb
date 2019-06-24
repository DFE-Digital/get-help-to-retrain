require 'rails_helper'

RSpec.describe ExploreOccupationsHelper do
  describe '.job_profile_category_list' do
    it 'returns a category for a given job profile' do
      job_profile = create(:job_profile)
      create(:category, name: 'Administration', job_profiles: [job_profile])

      expect(helper.job_profile_category_list(job_profile)).to match(/Administration/)
    end
  end
end
