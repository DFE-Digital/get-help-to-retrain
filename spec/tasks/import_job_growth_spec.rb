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

  it 'updates matching job profiles' do
    expect { task.execute(filename: path) }.not_to raise_exception

    expect(ceo.soc).to eq '1115'
    expect(ceo.extended_soc).to eq '1115A'
    expect(ceo.growth).to be_within(0.1).of(72.6)
  end
end
