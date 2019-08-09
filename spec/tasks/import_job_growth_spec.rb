require 'rails_helper'
require 'support/tasks'

RSpec.describe 'rake data_import:import_job_growth' do
  let(:path) { Rails.root.join('spec', 'fixtures', 'files', 'job_profile_growth.xlsx').to_s }
  let(:ceo) { JobProfile.find_by_name('chief executive') }

  before do
    create :job_profile, name: 'Chief executive'
  end

  it 'raises error if no filename' do
    expect { task.execute }.to raise_exception(SystemExit)
  end

  it 'raises error if invalid filename' do
    expect { task.execute(filename: 'foo.xlsx') }.to raise_exception(IOError)
  end

  it 'does not raise error with valid filename' do
    expect { task.execute(filename: path) }.not_to raise_exception
  end

  it 'updates matching job profiles' do
    task.execute(filename: path)
    expect(ceo).to have_attributes(soc: '1115', extended_soc: '1115A', growth: (a_value > 72))
  end
end
