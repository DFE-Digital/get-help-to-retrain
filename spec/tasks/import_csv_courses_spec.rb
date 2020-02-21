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

  it 'deletes existing course details records' do
    create(:course_detail, name: 'Old course')
    task.execute(folder: folder)

    expect(Csv::CourseDetail.where(name: 'Old course')).to be_empty
  end

  it 'deletes existing provider records' do
    create(:provider, name: 'Old provider')
    task.execute(folder: folder)

    expect(Csv::Provider.where(name: 'Old provider')).to be_empty
  end

  it 'deletes existing venue records' do
    create(:venue, name: 'Old venue')
    task.execute(folder: folder)

    expect(Csv::Venue.where(name: 'Old venue')).to be_empty
  end

  it 'deletes existing opportunity records' do
    create(:opportunity, url: 'www.old-url.com')
    task.execute(folder: folder)

    expect(Csv::Opportunity.where(url: 'www.old-url.com')).to be_empty
  end

  it 'deletes existing opportunity start date records' do
    date = Date.parse('6-6-666')
    create(:opportunity_start_date, start_date: date)
    task.execute(folder: folder)

    expect(Csv::OpportunityStartDate.where(start_date: date)).to be_empty
  end

  it 'deletes existing course lookup records' do
    create(:course_lookup, subject: 'old subject')
    task.execute(folder: folder)

    expect(Csv::Course.where(subject: 'old subject')).to be_empty
  end

  xit 'creates new csv detailed courses' do
    expect { task.execute(filename: folder) }.to change(Csv::CourseDetail, :count).by(4)
  end

  xit 'creates new csv providers' do
    expect { task.execute(filename: folder) }.to change(Csv::Provider, :count).by(4)
  end

  xit 'creates new csv venues for providers' do
    expect { task.execute(filename: folder) }.to change(Csv::Venue, :count).by(4)
  end

  xit 'creates new csv opportunities for detailed courses' do
    expect { task.execute(filename: folder) }.to change(Csv::Opportunity, :count).by(4)
  end

  xit 'creates new csv opportunity start dates' do
    expect { task.execute(filename: folder) }.to change(Csv::OpportunityStartDate, :count).by(2)
  end

  xit 'creates new course lookups' do
    expect { task.execute(filename: folder) }.to change(Csv::Course, :count).by(3)
  end
end
