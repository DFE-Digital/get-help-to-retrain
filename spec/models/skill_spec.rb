require 'rails_helper'

RSpec.describe Skill do
  let(:skill) { FactoryBot.build_stubbed(:skill) }
  let(:job_profile) { FactoryBot.build_stubbed(:job_profile) }

  describe 'relationships' do
    before do
      skill.job_profiles << job_profile
    end

    it 'has many job profiles' do
      expect(skill.job_profiles).to match [job_profile]
    end
  end
end
