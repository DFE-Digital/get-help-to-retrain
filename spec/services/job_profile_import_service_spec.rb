require 'rails_helper'

RSpec.describe JobProfileImportService do
  subject(:importer) { described_class.new }

  let(:path) { Rails.root.join('spec', 'fixtures', 'files', 'job_profile_growth.xlsx').to_s }
  let(:ceo) { JobProfile.find_by_name('Chief executive') }

  before do
    create :job_profile, name: 'Chief executive'
    create :job_profile, name: 'Monkey handler'
  end

  describe '#import_growth' do
    it 'raises error if invalid filename' do
      expect { importer.import_growth('foo.xlsx') }.to raise_exception(IOError)
    end

    it 'does not raise error with valid filename' do
      expect { importer.import_growth(path) }.not_to raise_exception
    end

    it 'updates matching job profiles' do
      importer.import_growth(path)
      expect(ceo).to have_attributes(soc: '1115', extended_soc: '1115A', growth: (a_value > 72))
    end
  end

  describe '#import_growth_stats' do
    before { importer.import_growth(path) }

    it 'reports statistics on completion' do
      expect(importer.import_growth_stats).to eq(
        job_profiles_total: 2,
        job_profiles_with_growth: 1,
        job_profiles_missing_growth: 1,
        errors: 2
      )
    end
  end
end
