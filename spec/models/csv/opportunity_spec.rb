require 'rails_helper'

RSpec.describe Csv::Opportunity, type: :model do
  describe '.valid_qualifications' do
    it 'excludes opportunities with certain qualification types' do
      described_class::QUALIFICATION_TYPE.each do |qualification_type|
        create(:opportunity, course: create(:csv_course, qualification_type: qualification_type))
      end

      expect(described_class.valid_qualifications).to be_empty
    end

    it 'excludes opportunities with certain qualification levels' do
      described_class::QUALIFICATION_LEVEL.each do |qualification_level|
        create(:opportunity, course: create(:csv_course, qualification_level: qualification_level))
      end

      expect(described_class.valid_qualifications).to be_empty
    end

    it 'excludes opportunities if they have the correct qualification type but not level' do
      create(
        :opportunity,
        course: create(
          :csv_course,
          qualification_level: 'LV8',
          qualification_type: 'some valid qualification'
        )
      )

      expect(described_class.valid_qualifications).to be_empty
    end

    it 'excludes opportunities if they have the correct level but not qualification type' do
      create(
        :opportunity,
        course: create(
          :csv_course,
          qualification_level: 'LV1',
          qualification_type: 'Foundation degree'
        )
      )

      expect(described_class.valid_qualifications).to be_empty
    end

    it 'includes opportunities with the correct qualification type and level' do
      opportunity = create(
        :opportunity,
        course: create(
          :csv_course,
          qualification_level: 'LV1',
          qualification_type: 'Some valid qualification'
        )
      )

      create(
        :opportunity,
        course: create(
          :csv_course,
          qualification_level: 'LV8',
          qualification_type: 'Some valid qualification'
        )
      )

      expect(described_class.valid_qualifications).to contain_exactly(opportunity)
    end

    it 'includes multiple opportunities for a course' do
      course = create(
        :csv_course,
        qualification_level: 'LV1',
        qualification_type: 'Some valid qualification'
      )
      opportunity_1 = create(:opportunity, course: course)
      opportunity_2 = create(:opportunity, course: course)
      create(
        :opportunity,
        course: create(
          :csv_course,
          qualification_level: 'LV8',
          qualification_type: 'Some valid qualification'
        )
      )

      expect(described_class.valid_qualifications).to contain_exactly(opportunity_1, opportunity_2)
    end
  end
end
