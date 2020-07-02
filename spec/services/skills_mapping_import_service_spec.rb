require 'rails_helper'

RSpec.describe SkillsMappingImportService do
  subject(:importer) { described_class.new }

  let(:skills_mappings_path) {
    Rails.root.join('spec', 'fixtures', 'files', 'skills_master.xlsx').to_s
  }

  let!(:skill_with_synonyms) {
    create(
      :skill,
      name: 'thinking and reasoning skills and the confidence to act quickly',
      master_name: nil
    )
  }

  let!(:skill_without_synonyms) {
    create(
      :skill,
      name: 'a good memory',
      master_name: nil
    )
  }

  describe 'Sensitivity to PROD ENV' do
    it 'does not run directly on a PROD ENV for safety' do
      allow(Rails.env).to receive(:production?).and_return(true)

      expect {
        importer
      }.to raise_error('Not to be run in production')
    end
  end

  describe '#import' do
    it 'raises error if invalid filename' do
      expect { importer.import('foo.xlsx') }.to raise_exception(IOError)
    end

    it 'does not raise error with valid filename' do
      expect { importer.import(skills_mappings_path) }.not_to raise_exception
    end

    it 'updates the master_name with the synonym if that exists' do
      importer.import(skills_mappings_path)

      expect(skill_with_synonyms.reload.master_name).to eq('thinking and reasoning skills')
    end

    it 'updates the master_name with the actual name if a synonym does not exist' do
      importer.import(skills_mappings_path)

      expect(skill_without_synonyms.reload.master_name).to eq('a good memory')
    end

    it 'overwrites old master_name value for any skill on runtime' do
      skill = create(:skill, name: 'concentration skills and a steady hand', master_name: 'old_mapping')

      importer.import(skills_mappings_path)

      expect(skill.reload.master_name).to eq('concentration skills')
    end
  end

  describe '#import_stats' do
    it 'reports statistics on completion' do
      create(:skill, name: 'concentration skills and fast reactions')
      create(:skill, name: 'physical skills like movement, coordination and dexterity')

      importer.import(skills_mappings_path)

      expect(importer.import_stats).to eq(
        skills_with_synonyms: 3,
        skills_without_synonyms: 1,
        unmapped_skills: 0
      )
    end
  end
end
