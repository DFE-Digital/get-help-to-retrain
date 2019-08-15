require 'rails_helper'
require 'support/tasks'

RSpec.describe 'data_import:update_recommended_job_profiles' do
  let!(:astronaut) { create :job_profile, slug: 'astronaut' }
  let!(:mad_titan) { create :job_profile, slug: 'mad-titan' }

  it 'excludes specific named jobs' do
    task.execute
    expect(astronaut.reload).not_to be_recommended
  end

  it 'recommends all other jobs' do
    task.execute
    expect(mad_titan.reload).to be_recommended
  end
end
