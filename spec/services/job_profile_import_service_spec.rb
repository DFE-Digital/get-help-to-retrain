require 'rails_helper'

RSpec.describe JobProfileImportService do
  subject(:importer) { described_class.new }

  let(:growth_path) { Rails.root.join('spec', 'fixtures', 'files', 'job_profile_growth.xlsx').to_s }
  let(:additional_data_path) { Rails.root.join('spec', 'fixtures', 'files', 'job_profile_additional_data.xlsx').to_s }
  let(:ceo) { JobProfile.find_by_name('Chief executive') }

  before do
    create :job_profile, name: 'Chief executive', slug: 'chief-executive'
    create :job_profile, name: 'Monkey handler', slug: 'monkey-handler'
  end

  describe '#import_growth' do
    it 'raises error if invalid filename' do
      expect { importer.import_growth('foo.xlsx') }.to raise_exception(IOError)
    end

    xit 'does not raise error with valid filename' do
      expect { importer.import_growth(growth_path) }.not_to raise_exception
    end

    xit 'updates matching job profiles' do
      importer.import_growth(growth_path)
      expect(ceo).to have_attributes(soc: '1115', extended_soc: '1115A', growth: (a_value > 72))
    end
  end

  describe '#import_growth_stats' do
    before { importer.import_growth(growth_path) }

    xit 'reports statistics on completion' do
      expect(importer.import_growth_stats).to eq(
        job_profiles_total: 2,
        job_profiles_with_growth: 1,
        job_profiles_missing_growth: 1,
        errors: 2
      )
    end
  end

  describe '#import_additional_data' do
    it 'raises error if invalid filename' do
      expect { importer.import_additional_data('foo.xlsx') }.to raise_exception(IOError)
    end

    it 'does not raise error with valid filename' do
      expect { importer.import_additional_data(additional_data_path) }.not_to raise_exception
    end

    it 'updates matching job profiles' do
      importer.import_additional_data(additional_data_path)
      expect(ceo).to have_attributes(hidden_titles: 'Boss man,Big cheese', specialism: 'ufc,wrestler,wwe')
    end

    it 'updates values when they have been removed from the spreadsheet' do
      acupuncturist = create(
        :job_profile,
        name: 'Acupuncturist',
        slug: 'acupuncturist',
        specialism: ''
      )
      importer.import_additional_data(additional_data_path)

      expect(acupuncturist.reload.specialism).to be_nil
    end
  end

  describe '#import_additional_data_stats' do
    before { importer.import_additional_data(additional_data_path) }

    it 'reports statistics on completion' do
      expect(importer.import_additional_data_stats).to eq(
        job_profiles_total: 2,
        job_profiles_with_hidden_titles: 1,
        job_profiles_missing_hidden_titles: 1,
        job_profiles_with_specialism: 1,
        job_profiles_missing_specialism: 1,
        errors: 2
      )
    end
  end
end
