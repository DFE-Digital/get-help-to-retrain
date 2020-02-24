require 'rails_helper'

RSpec.describe Csv::Persistor::Course do
  let(:folder) { Rails.root.join('spec', 'fixtures', 'files', 'csv').to_s }

  describe '#persist!' do
    it 'persists all records in csv' do
      create(:provider, external_provider_id: 301_751)
      create(:provider, external_provider_id: 304_241)
      create(:provider, external_provider_id: 300_989)
      create(:provider, external_provider_id: 304_095)

      expect { described_class.new(folder).persist! }.to change(Csv::Course, :count).by(4)
    end

    it 'sets the correct attributes for a course' do
      provider = create(:provider, external_provider_id: 301_751)
      create(:provider, external_provider_id: 304_241)
      create(:provider, external_provider_id: 300_989)
      create(:provider, external_provider_id: 304_095)

      described_class.new(folder).persist!
      expect(Csv::Course.first).to have_attributes(
        external_course_id: 50_559_039,
        name: 'Edexcel Entry Level Award in ESOL Skills for Life(Entry 3)',
        qualification_type: 'Other regulated/accredited qualification',
        qualification_name: 'Award in ESOL Skills for Life (speaking and listening) (Entry 3)',
        qualification_level: 'LV0',
        description: /Learners will learn/,
        url: 'https://micomputsolutions.co.uk/courses/esol-skills-for-life/',
        booking_url: 'https://micomputsolutions.co.uk/courses/development/registration-and-eligibility/?course=ESOL-Skills-for-Life-and-Work',
        provider: provider
      )
    end

    it 'is linked to correct provider' do
      create(:provider, external_provider_id: 301_751)
      create(:provider, external_provider_id: 304_241)
      create(:provider, external_provider_id: 304_095)

      provider = create(:provider, external_provider_id: 300_989)
      described_class.new(folder).persist!

      expect(provider.courses.count).to eq(1)
    end

    it 'fails if no provider found' do
      expect { described_class.new(folder).persist! }.to raise_exception(ActiveRecord::RecordInvalid)
    end
  end
end
