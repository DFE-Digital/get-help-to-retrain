require 'rails_helper'
require 'support/tasks'

RSpec.describe 'rake data_import:import_courses' do
  let(:path) { Rails.root.join('spec', 'fixtures', 'files', 'courses.xlsx').to_s }

  before do
    Geocoder::Lookup::Test.add_stub('NW11 8QE', [{ 'coordinates' => [0.1, 0.2] }])
    Geocoder::Lookup::Test.add_stub('NW6 8ET', [{ 'coordinates' => [] }])
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

  it 'creates courses' do
    expect { task.execute(filename: path) }.to change(Course, :count).by(2)
  end
end
