require 'rails_helper'

RSpec.describe Category do
  let(:category) { build_stubbed(:category) }
  let(:job_profile) { build_stubbed(:job_profile) }

  describe 'relationships' do
    before do
      category.job_profiles << job_profile
    end

    it 'has many job profiles' do
      expect(category.job_profiles).to match [job_profile]
    end
  end

  describe '.with_job_profiles' do
    it 'returns categories with job profiles' do
      category = create(:category, :with_job_profile)
      expect(described_class.with_job_profiles).to contain_exactly(category)
    end

    it 'returns unique categories with job profiles' do
      create(
        :category,
        job_profiles: [
          create(:job_profile),
          create(:job_profile)
        ]
      )
      expect(described_class.with_job_profiles.count).to eq(1)
    end

    it 'does not return categories not linked to job profiles' do
      category = create(:category, :with_job_profile)
      create(:category)
      expect(described_class.with_job_profiles).to contain_exactly(category)
    end

    it 'returns nothing if no categories linked to job profiles' do
      create_list(:category, 2)
      expect(described_class.with_job_profiles).to be_empty
    end
  end

  describe '.with_job_profiles_without' do
    it 'returns categories with job profiles without passed in category' do
      category1 = create(:category, :with_job_profile, name: 'Administration')
      category2 = create(:category, :with_job_profile, name: 'Education')
      expect(described_class.with_job_profiles_without(category1)).to contain_exactly(category2)
    end

    it 'returns categories with job profiles if category empty' do
      category = create(:category, :with_job_profile, name: 'Administration')
      expect(described_class.with_job_profiles_without(nil)).to contain_exactly(category)
    end
  end

  describe '.import' do
    subject(:import) { described_class.import('foo', 'https://foobar.com') }

    context 'with new category' do
      it 'creates the category' do
        expect { import }.to change(described_class, :count).by(1)
      end

      it 'sets the default name from slug' do
        import
        expect(described_class.last.name).to eq 'Foo'
      end
    end

    context 'with existing category' do
      before { create :category, slug: 'foo', name: 'Bar' }

      it 'does not creates a new category' do
        expect { import }.not_to change(described_class, :count)
      end

      it 'does not overwrite existing name' do
        import
        expect(described_class.last.name).to eq 'Bar'
      end
    end
  end

  describe '#scrape', vcr: { cassette_name: 'explore_my_careers_category' } do
    let(:slug) { 'administration' }
    let(:url) { 'https://nationalcareers.service.gov.uk/job-categories/administration' }
    let(:category) { build :category, slug: slug, source_url: url }
    let!(:bookkeeper) { create :job_profile, slug: 'bookkeeper' }

    before { category.scrape }

    it 'updates name with scraped title' do
      expect(category.name).to eq 'Administration'
    end

    it 'updates job profiles with scraped links' do
      expect(category.job_profiles).to include bookkeeper
    end
  end
end
