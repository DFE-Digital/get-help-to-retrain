require 'rails_helper'

RSpec.describe Csv::Persistor::Opportunity do
  let(:row) do
    CSV.read(
      Rails.root.join('spec', 'fixtures', 'files', 'csv', described_class::FILENAME),
      headers: true
    ).first
  end

  describe '#persist!' do
    it 'sets the correct attributes for a opportunity' do
      venue = create(:venue, external_venue_id: 3_041_969)
      course = create(:csv_course, external_course_id: 50_559_039)

      described_class.new(row).persist!
      expect(Csv::Opportunity.first).to have_attributes(
        external_opportunities_id: 922_907,
        attendance_modes: 'Work-based',
        attendance_pattern: 'Daytime/working hours',
        study_modes: 'Flexible',
        end_date: nil,
        duration_value: 12,
        duration_type: 'Week',
        duration_description: nil,
        start_date_description: /This is a Roll on Roll off course/,
        price: 300.00,
        price_description: /Free of charge/,
        url: nil,
        venue: venue,
        course: course
      )
    end

    it 'is linked to correct course' do
      course = create(:csv_course, external_course_id: 50_559_039)
      create(:venue, external_venue_id: 3_041_969)

      described_class.new(row).persist!

      expect(course.opportunities.count).to eq(1)
    end

    it 'is linked to correct venue' do
      create(:csv_course, external_course_id: 50_559_039)
      venue = create(:venue, external_venue_id: 3_041_969)

      described_class.new(row).persist!

      expect(venue.opportunities.count).to eq(1)
    end

    it 'fails if no course found' do
      create(:venue, external_venue_id: 3_041_969)

      expect { described_class.new(row).persist! }.to raise_exception(ActiveRecord::RecordInvalid)
    end

    it 'persists opportunities not linked to any venues' do
      create(:csv_course, external_course_id: 50_559_039)

      described_class.new(row).persist!

      expect { described_class.new(row).persist! }.to change(Csv::Opportunity, :count).by(1)
    end

    it 'sets the correct study mode' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)
      modes = {
        'SM1' => 'Full time',
        'SM2' => 'Part time',
        'SM3' => 'Part of a full-time program',
        'SM4' => 'Flexible',
        'SM5' => 'Not known'
      }

      modes.each do |mode, value|
        row['STUDY_MODE'] = mode
        described_class.new(row).persist!

        expect(Csv::Opportunity.last.study_modes).to eq(value)
      end
    end

    it 'returns nil if study mode is not set' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)

      row['STUDY_MODE'] = nil
      described_class.new(row).persist!

      expect(Csv::Opportunity.first.study_modes).to be_nil
    end

    it 'returns no matching value if study mode has no matching mode' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)

      row['STUDY_MODE'] = 'unknown code'
      described_class.new(row).persist!

      expect(Csv::Opportunity.first.study_modes).to eq('unknown code')
    end

    it 'sets the correct attendance mode' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)
      modes = {
        'AM1' => 'Location / campus',
        'AM2' => 'Face-to-face (non-campus)',
        'AM3' => 'Work-based',
        'AM4' => 'Mixed Mode',
        'AM5' => 'Distance with attendance',
        'AM6' => 'Distance without attendance',
        'AM7' => 'Online without attendance',
        'AM8' => 'Online with attendance',
        'AM9' => 'Not known'
      }

      modes.each do |mode, value|
        row['ATTENDANCE_MODE'] = mode
        described_class.new(row).persist!

        expect(Csv::Opportunity.last.attendance_modes).to eq(value)
      end
    end

    it 'returns nil if attendance mode is not set' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)

      row['ATTENDANCE_MODE'] = nil
      described_class.new(row).persist!

      expect(Csv::Opportunity.first.attendance_modes).to be_nil
    end

    it 'returns no matching value if attendance mode has no matching mode' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)

      row['ATTENDANCE_MODE'] = 'unknown code'
      described_class.new(row).persist!

      expect(Csv::Opportunity.first.attendance_modes).to eq('unknown code')
    end

    it 'sets the correct attendance pattern' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)
      modes = {
        'AP1' => 'Daytime/working hours',
        'AP2' => 'Day/Block release',
        'AP3' => 'Evening',
        'AP4' => 'Twilight',
        'AP5' => 'Weekend',
        'AP6' => 'Customised',
        'AP7' => 'Not known',
        'AP8' => 'Not applicable'
      }

      modes.each do |pattern, value|
        row['ATTENDANCE_PATTERN'] = pattern
        described_class.new(row).persist!

        expect(Csv::Opportunity.last.attendance_pattern).to eq(value)
      end
    end

    it 'returns nil if attendance pattern is not set' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)

      row['ATTENDANCE_PATTERN'] = nil
      described_class.new(row).persist!

      expect(Csv::Opportunity.first.attendance_pattern).to be_nil
    end

    it 'returns no matching value if attendance pattern has no matching pattern' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)

      row['ATTENDANCE_PATTERN'] = 'unknown code'
      described_class.new(row).persist!

      expect(Csv::Opportunity.first.attendance_pattern).to eq('unknown code')
    end

    it 'sets the correct duration unit' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)
      modes = {
        'DU1' => 'Hour',
        'DU2' => 'Day',
        'DU3' => 'Week',
        'DU4' => 'Month',
        'DU5' => 'Term',
        'DU6' => 'Semester',
        'DU7' => 'Year'
      }

      modes.each do |unit, value|
        row['DURATION_UNITS'] = unit
        described_class.new(row).persist!

        expect(Csv::Opportunity.last.duration_type).to eq(value)
      end
    end

    it 'returns nil if duration unit is not set' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)

      row['DURATION_UNITS'] = nil
      described_class.new(row).persist!

      expect(Csv::Opportunity.first.duration_type).to be_nil
    end

    it 'returns no matching value if duration unit has no matching unit' do
      create(:venue, external_venue_id: 3_041_969)
      create(:csv_course, external_course_id: 50_559_039)

      row['DURATION_UNITS'] = 'unknown code'
      described_class.new(row).persist!

      expect(Csv::Opportunity.first.duration_type).to eq('unknown code')
    end
  end
end
