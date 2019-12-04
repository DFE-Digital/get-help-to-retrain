require 'rails_helper'

RSpec.describe JobVacancy do
  describe '#title' do
    it 'returns the title from a parsed body' do
      body = { 'title' => 'Some title' }
      expect(described_class.new(body).title).to eq('Some title')
    end

    it 'returns nil if title missing' do
      body = {}
      expect(described_class.new(body).title).to be_nil
    end
  end

  describe '#url' do
    it 'returns the url from a parsed body' do
      body = { 'url' => 'https://example.com' }
      expect(described_class.new(body).url).to eq('https://example.com')
    end

    it 'returns nil if url is missing' do
      body = {}
      expect(described_class.new(body).url).to be_nil
    end
  end

  describe '#closing_date' do
    it 'returns the closing date from a parsed body' do
      body = { 'closing' => '2019-10-11T18:56:40' }
      expect(described_class.new(body).closing_date).to eq('2019-10-11T18:56:40')
    end

    it 'returns nil if closing date is empty' do
      body = { 'closing' => '' }
      expect(described_class.new(body).closing_date).to be_nil
    end

    it 'returns nil if closing date is missing' do
      body = {}
      expect(described_class.new(body).closing_date).to be_nil
    end
  end

  describe '#date_posted' do
    it 'returns the posted date from a parsed body' do
      body = { 'posted' => '2019-10-11T18:56:40' }
      expect(described_class.new(body).date_posted).to eq('2019-10-11T18:56:40')
    end

    it 'returns nil if posted date is empty' do
      body = { 'posted' => '' }
      expect(described_class.new(body).date_posted).to be_nil
    end

    it 'returns nil if posted date is missing' do
      body = {}
      expect(described_class.new(body).date_posted).to be_nil
    end
  end

  describe '#company' do
    it 'returns the company from a parsed body' do
      body = { 'company' => 'University College London' }
      expect(described_class.new(body).company)
        .to eq('University College London')
    end

    it 'returns nil if the company is empty' do
      body = { 'company' => '' }
      expect(described_class.new(body).company).to be_nil
    end

    it 'returns nil if company is missing' do
      body = {}
      expect(described_class.new(body).company).to be_nil
    end
  end

  describe '#location' do
    it 'returns the location from a parsed body' do
      body = { 'location' => 'London, UK' }
      expect(described_class.new(body).location).to eq('London, UK')
    end

    it 'returns nil if the location is empty' do
      body = { 'location' => '' }
      expect(described_class.new(body).location).to be_nil
    end

    it 'returns nil if location is missing' do
      body = {}
      expect(described_class.new(body).location).to be_nil
    end
  end

  describe '#salary' do
    it 'returns the salary from a parsed body' do
      body = { 'salary' => '£21 to £22 per hour' }
      expect(described_class.new(body).salary).to eq('£21 to £22 per hour')
    end

    it 'returns nil if the salary is empty' do
      body = { 'salary' => '' }
      expect(described_class.new(body).salary).to be_nil
    end

    it 'returns nil if salary is missing' do
      body = {}
      expect(described_class.new(body).salary).to be_nil
    end
  end

  describe '#description' do
    it 'returns the description from a parsed body' do
      body = { 'description' => 'Division Information Services Division' }
      expect(described_class.new(body).description).to eq('Division Information Services Division')
    end

    it 'returns truncated description if text longer than 260 characters' do
      body = {
        'description' => 'UCL Department / Division Information Services Division Specific unit \
        Sub department Shared Services / Resource Pool Location of position London Grade 8 Hours \
        Full Time Salary (inclusive of London allowance) Competitve Duties and Responsibilities  \
        Are you a Development Manager looking to manage a large team of developers or a Team Lead'
      }

      expect(described_class.new(body).description).to eq(
        'UCL Department / Division Information Services Division Specific unit \
        Sub department Shared Services / Resource Pool Location of position London Grade 8 Hours \
        Full Time Salary (inclusive of London allowance) Competitve Duties and Respons...'
      )
    end

    it 'returns nil if description is empty' do
      body = { 'description' => '' }
      expect(described_class.new(body).description).to be_nil
    end

    it 'returns nil if description is missing' do
      body = {}
      expect(described_class.new(body).description).to be_nil
    end
  end
end
