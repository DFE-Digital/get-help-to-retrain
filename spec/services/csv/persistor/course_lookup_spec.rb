require 'rails_helper'

RSpec.describe Csv::Persistor::CourseLookup do
  describe '#persist!' do
    it 'sets the correct attributes for a course lookup' do
      opportunity = create(
        :opportunity,
        study_modes: 'Full time',
        attendance_modes: 'Location / campus',
        course: create(:csv_course, name: 'english')
      )

      Geocoder::Lookup::Test.add_stub(
        opportunity.venue.postcode, [{ 'coordinates' => [0.1, 1] }]
      )

      described_class.new(opportunity).persist!
      expect(Csv::CourseLookup.first).to have_attributes(
        subject: 'english',
        addressable: opportunity.venue,
        hours: 'Full time',
        delivery_type: 'Classroom based',
        postcode: opportunity.venue.postcode,
        latitude: 0.1,
        longitude: 1,
        opportunity: opportunity
      )
    end

    it 'sets addressable as venue if venue exists' do
      opportunity = create(
        :opportunity,
        study_modes: 'Full time',
        attendance_modes: 'Location / campus',
        course: create(:csv_course, name: 'english'),
        venue: create(:venue, postcode: 'L1 0BG')
      )

      described_class.new(opportunity).persist!

      expect(Csv::CourseLookup.first.addressable).to eq(opportunity.venue)
    end

    it 'sets addressable as provider if opportunity has no venue' do
      opportunity = create(
        :opportunity,
        study_modes: 'Full time',
        attendance_modes: 'Classroom based',
        course: create(:csv_course, name: 'english'),
        venue: nil
      )

      described_class.new(opportunity).persist!

      expect(Csv::CourseLookup.first.addressable).to eq(opportunity.course.provider)
    end

    it 'sets postcode from venue if venue exists' do
      opportunity = create(
        :opportunity,
        study_modes: 'Full time',
        attendance_modes: 'Location / campus',
        course: create(:csv_course, name: 'english'),
        venue: create(:venue, postcode: 'L1 0BG')
      )

      described_class.new(opportunity).persist!

      expect(Csv::CourseLookup.first.postcode).to eq('L1 0BG')
    end

    it 'sets postcode from provider if opportunity has no venue' do
      opportunity = create(
        :opportunity,
        study_modes: 'Full time',
        attendance_modes: 'Location / campus',
        course: create(:csv_course, name: 'english'),
        venue: nil
      )

      described_class.new(opportunity).persist!

      expect(Csv::CourseLookup.first.postcode).to eq(opportunity.course.provider.postcode)
    end

    it 'does not create lookup if course name does not fall under a subject' do
      opportunity = create(
        :opportunity,
        course: create(:csv_course, name: 'Physics')
      )

      expect { described_class.new(opportunity).persist! }.not_to change(Csv::CourseLookup, :count)
    end

    context 'when subject esol' do
      it 'sets subject to esol when course name has word esol' do
        opportunity = create(
          :opportunity,
          course: create(:csv_course, name: 'some ESOL course')
        )

        described_class.new(opportunity).persist!

        expect(Csv::CourseLookup.first.subject).to eq('esol')
      end

      it 'sets subject to esol when course name has words english for speakers of other languages' do
        opportunity = create(
          :opportunity,
          course: create(:csv_course, name: 'Some english for speakers of Other languages course')
        )

        described_class.new(opportunity).persist!

        expect(Csv::CourseLookup.first.subject).to eq('esol')
      end

      it 'does not create lookup if course name has esol and resolution' do
        opportunity = create(
          :opportunity,
          course: create(:csv_course, name: 'some Resolution English for speakers of other Languages course')
        )

        described_class.new(opportunity).persist!

        expect { described_class.new(opportunity).persist! }.not_to change(Csv::CourseLookup, :count)
      end

      it 'does not create lookup if course name has esol and resolving' do
        opportunity = create(
          :opportunity,
          course: create(:csv_course, name: 'some esol course with resoLving')
        )

        described_class.new(opportunity).persist!

        expect { described_class.new(opportunity).persist! }.not_to change(Csv::CourseLookup, :count)
      end
    end

    context 'when subject maths' do
      it 'sets subject to maths when course name has word math' do
        opportunity = create(
          :opportunity,
          course: create(:csv_course, name: 'some Math course')
        )

        described_class.new(opportunity).persist!

        expect(Csv::CourseLookup.first.subject).to eq('maths')
      end

      it 'does not create lookup if course name has math and aromath' do
        opportunity = create(
          :opportunity,
          course: create(:csv_course, name: 'some aroMath course')
        )

        described_class.new(opportunity).persist!

        expect { described_class.new(opportunity).persist! }.not_to change(Csv::CourseLookup, :count)
      end
    end

    context 'when subject english' do
      it 'sets subject to maths when course name has word english' do
        opportunity = create(
          :opportunity,
          course: create(:csv_course, name: 'some english course')
        )

        described_class.new(opportunity).persist!

        expect(Csv::CourseLookup.first.subject).to eq('english')
      end

      it 'does not create lookup if course name has english and esol' do
        opportunity = create(
          :opportunity,
          course: create(:csv_course, name: 'some Esol english resolution')
        )

        described_class.new(opportunity).persist!

        expect { described_class.new(opportunity).persist! }.not_to change(Csv::CourseLookup, :count)
      end

      it 'does not create lookup if course name has english and social' do
        opportunity = create(
          :opportunity,
          course: create(:csv_course, name: 'Social to EnglisH course')
        )

        described_class.new(opportunity).persist!

        expect { described_class.new(opportunity).persist! }.not_to change(Csv::CourseLookup, :count)
      end

      it 'does not create lookup if course name has english and english for speakers of other languages' do
        opportunity = create(
          :opportunity,
          course: create(:csv_course, name: 'some Resolution English for speakers of other Languages english course')
        )

        described_class.new(opportunity).persist!

        expect { described_class.new(opportunity).persist! }.not_to change(Csv::CourseLookup, :count)
      end

      it 'does not persist a lookup if opportunity study mode is part of a full time program' do
        opportunity = create(
          :opportunity,
          study_modes: 'Part of a full-time program',
          course: create(:csv_course, name: 'english')
        )

        expect { described_class.new(opportunity).persist! }.not_to change(Csv::CourseLookup, :count)
      end

      it 'does not persist a lookup if opportunity attendance mode is work based' do
        opportunity = create(
          :opportunity,
          attendance_modes: 'Work-based',
          course: create(:csv_course, name: 'english')
        )

        expect { described_class.new(opportunity).persist! }.not_to change(Csv::CourseLookup, :count)
      end

      it 'maps attendance modes to filter terms' do
        modes = {
          'Location / campus' => 'Classroom based',
          'Face-to-face (non-campus)' => 'Classroom based',
          'Mixed Mode' => 'Classroom based',
          'Distance with attendance' => 'Distance learning',
          'Distance without attendance' => 'Distance learning',
          'Online without attendance' => 'Online',
          'Online with attendance' => 'Online',
          'Not known' => 'Not known',
          nil => nil
        }

        modes.each do |mode, value|
          opportunity = create(
            :opportunity,
            attendance_modes: mode,
            course: create(:csv_course, name: 'english')
          )

          described_class.new(opportunity).persist!

          expect(Csv::CourseLookup.last.delivery_type).to eq(value)
        end
      end
    end
  end
end
