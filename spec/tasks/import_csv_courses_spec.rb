require 'rails_helper'
require 'support/tasks'

RSpec.describe 'rake data_import:import_csv_courses' do
  let(:folder) { Rails.root.join('spec', 'fixtures', 'files', 'csv').to_s }

  it 'raises error if no folder name supplied' do
    expect { task.execute }.to raise_exception(SystemExit)
  end

  it 'does not raise error with valid folder' do
    expect { task.execute(folder: folder) }.not_to raise_exception
  end

  it 'creates new csv courses' do
    expect { task.execute(filename: folder) }.to change(Csv::Course, :count).by(4)
  end

  it 'creates new csv providers' do
    expect { task.execute(filename: folder) }.to change(Csv::Provider, :count).by(4)
  end

  it 'creates new csv venues for providers' do
    expect { task.execute(filename: folder) }.to change(Csv::Venue, :count).by(4)
  end

  it 'creates new csv opportunities for courses' do
    expect { task.execute(filename: folder) }.to change(Csv::Opportunity, :count).by(4)
  end

  it 'creates new csv opportunity start dates' do
    expect { task.execute(filename: folder) }.to change(Csv::OpportunityStartDate, :count).by(2)
  end

  it 'creates new course lookups' do
    expect { task.execute(filename: folder) }.to change(Csv::CourseLookup, :count).by(3)
  end
end
