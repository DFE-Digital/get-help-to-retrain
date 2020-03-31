require 'rails_helper'

RSpec.describe JobProfileSearchService do
  subject(:importer) { described_class.new }

  let(:search_path) { Rails.root.join('spec', 'fixtures', 'files', 'job_profile_search.xlsx').to_s }

  describe '#import' do
    it 'raises error if invalid filename' do
      expect { importer.import('foo.xlsx') }.to raise_exception(IOError)
    end

    it 'does not raise error with valid filename' do
      expect { importer.import(search_path) }.not_to raise_exception
    end

    it 'ignores words with meaningless and doubtful types' do
      create(:job_profile, name: 'Chief and executive')
      create(:job_profile, name: 'Nurse Service')
      importer.import(search_path)

      expect(
        JobProfile
          .where.not(sector: nil)
          .where.not(hierarchy: nil)
          .count
      ).to be_zero
    end

    it 'updates sector words if they match a profile name' do
      job_profile = create(:job_profile, name: 'Therapist')
      importer.import(search_path)

      expect(job_profile.reload).to have_attributes(sector: 'therapist', hierarchy: nil)
    end

    it 'updates hierarchy words if they match a profile name' do
      job_profile = create(:job_profile, name: 'Technical Officer')
      importer.import(search_path)

      expect(job_profile.reload).to have_attributes(hierarchy: 'officer', sector: nil)
    end

    it 'updates sector words if they match a profile alternative title' do
      job_profile = create(:job_profile, alternative_titles: 'Therapist')
      importer.import(search_path)

      expect(job_profile.reload).to have_attributes(sector: 'therapist', hierarchy: nil)
    end

    it 'updates hierarchy words if they match a profile alternative title' do
      job_profile = create(:job_profile, alternative_titles: 'Technical Officer')
      importer.import(search_path)

      expect(job_profile.reload).to have_attributes(hierarchy: 'officer', sector: nil)
    end

    it 'updates sector words with alternatives if they match a profile' do
      job_profile = create(:job_profile, name: 'Physics teacher')
      importer.import(search_path)

      expect(job_profile.reload).to have_attributes(sector: 'teacher, lecturer')
    end

    it 'updates hierarchy words with alternatives if they match a profile' do
      job_profile = create(:job_profile, name: 'Technical Manager')
      importer.import(search_path)

      expect(job_profile.reload).to have_attributes(hierarchy: 'manager, management')
    end

    it 'appends new words to existing values in column' do
      job_profile = create(:job_profile, name: 'Officer manager')
      importer.import(search_path)

      expect(job_profile.reload).to have_attributes(hierarchy: 'manager, management, officer')
    end

    it 'resets hierarchy column on each run' do
      job_profile = create(:job_profile, name: 'Officer manager')
      importer.import(search_path)
      importer.import(search_path)

      expect(job_profile.reload).to have_attributes(hierarchy: 'manager, management, officer')
    end

    it 'resets sector column on each run' do
      job_profile = create(:job_profile, name: 'Physics teacher')
      importer.import(search_path)
      importer.import(search_path)

      expect(job_profile.reload).to have_attributes(sector: 'teacher, lecturer')
    end
  end

  describe '#import_stats' do
    it 'reports statistics on completion' do
      create(:job_profile, name: 'Therapist')
      create(:job_profile, name: 'Techincal engineer')
      create(:job_profile, name: 'Officer Manager')
      create(:job_profile, name: 'Teacher')
      create(:job_profile, name: 'Developer')

      importer.import(search_path)
      expect(importer.import_stats).to eq(
        job_profiles_with_hierarchy: 1,
        job_profiles_with_sector: 3,
        job_profiles_missing_search_value: 1
      )
    end
  end
end
