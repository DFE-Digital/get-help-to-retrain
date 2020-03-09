require 'rails_helper'

RSpec.describe SearchCourse do
  describe '#name' do
    it 'returns the name from a parsed body' do
      body = { 'courseName' => 'Some Name' }
      expect(described_class.new(body).name).to eq('Some Name')
    end

    it 'returns nil if name empty' do
      body = { 'courseName' => '' }
      expect(described_class.new(body).name).to be_nil
    end

    it 'returns nil if name is missing' do
      body = {}
      expect(described_class.new(body).name).to be_nil
    end
  end

  describe '#provider_name' do
    it 'returns the provider_name from a parsed body' do
      body = { 'providerName' => 'Some provider name' }
      expect(described_class.new(body).provider_name).to eq('Some provider name')
    end

    it 'returns nil if provider_name is empty' do
      body = { 'providerName' => '' }
      expect(described_class.new(body).provider_name).to be_nil
    end

    it 'returns nil if provider name is missing' do
      body = {}
      expect(described_class.new(body).provider_name).to be_nil
    end
  end

  describe '#course_hours' do
    it 'returns the course hours from a parsed body' do
      body = { 'venueStudyModeDescription' => 'Flexible' }
      expect(described_class.new(body).course_hours).to eq('Flexible')
    end

    it 'returns nil if course hours is empty' do
      body = { 'venueStudyModeDescription' => '' }
      expect(described_class.new(body).course_hours).to be_nil
    end

    it 'returns nil if course hours is missing' do
      body = {}
      expect(described_class.new(body).course_hours).to be_nil
    end
  end

  describe '#course_type' do
    it 'returns the course type from a parsed body' do
      body = { 'deliveryModeDescription' => 'Online' }
      expect(described_class.new(body).course_type).to eq('Online')
    end

    it 'returns nil if course type is empty' do
      body = { 'deliveryModeDescription' => '' }
      expect(described_class.new(body).course_type).to be_nil
    end

    it 'returns nil if course type is missing' do
      body = {}
      expect(described_class.new(body).course_type).to be_nil
    end
  end

  describe '#address' do
    it 'returns the address from a parsed body' do
      body = { 'venueAddress' => 'Queens Gardens Sites, Kingston Upon Hull, HU1 3DG' }
      expect(described_class.new(body).address)
        .to eq('Queens Gardens Sites, Kingston Upon Hull, HU1 3DG')
    end

    it 'returns nil if the address is empty' do
      body = { 'venueAddress' => '' }
      expect(described_class.new(body).address).to be_nil
    end

    it 'returns nil if address is missing' do
      body = {}
      expect(described_class.new(body).address).to be_nil
    end
  end

  describe '#distance' do
    it 'returns the distance from a parsed body' do
      body = { 'distance' => 1.2 }
      expect(described_class.new(body).distance)
        .to eq(1.2)
    end

    it 'returns nil if the distance is empty' do
      body = { 'distance' => nil }
      expect(described_class.new(body).distance).to be_nil
    end

    it 'returns nil if distance is missing' do
      body = {}
      expect(described_class.new(body).distance).to be_nil
    end
  end

  describe '#course_id' do
    it 'returns the course id from a parsed body' do
      body = { 'courseId' => '704a5728-e45f-43ae-9797-04c853f8d249' }
      expect(described_class.new(body).course_id)
        .to eq('704a5728-e45f-43ae-9797-04c853f8d249')
    end

    it 'returns nil if the course id is empty' do
      body = { 'courseId' => '' }
      expect(described_class.new(body).course_id).to be_nil
    end

    it 'returns nil if course id is missing' do
      body = {}
      expect(described_class.new(body).course_id).to be_nil
    end
  end

  describe '#course_run_id' do
    it 'returns the course run id from a parsed body' do
      body = { 'courseRunId' => 'ef8958f1-8bfc-4fa1-811c-e07c4dc056c6' }
      expect(described_class.new(body).course_run_id)
        .to eq('ef8958f1-8bfc-4fa1-811c-e07c4dc056c6')
    end

    it 'returns nil if the course run id is empty' do
      body = { 'courseRunId' => '' }
      expect(described_class.new(body).course_run_id).to be_nil
    end

    it 'returns nil if course run id is missing' do
      body = {}
      expect(described_class.new(body).course_run_id).to be_nil
    end
  end
end
