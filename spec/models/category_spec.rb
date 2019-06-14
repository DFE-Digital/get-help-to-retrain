require 'rails_helper'

RSpec.describe Category do
  let(:category) { FactoryBot.build_stubbed(:category) }
  let(:job_profile) { FactoryBot.build_stubbed(:job_profile) }

  describe 'relationships' do
    before do
      category.job_profiles << job_profile
    end

    it 'has many job profiles' do
      expect(category.job_profiles).to match [job_profile]
    end
  end
end
