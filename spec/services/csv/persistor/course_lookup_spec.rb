require 'rails_helper'

RSpec.describe Csv::Persistor::CourseLookup do
  describe '#persist!' do
    it 'sets the correct attributes for a course lookup' do
      opportunity = create(
        :opportunity,
        study_modes: 'study mode',
        attendance_modes: 'attendance mode',
        course: create(:csv_course, name: 'english')
      )

      Geocoder::Lookup::Test.add_stub(
        opportunity.venue.postcode, [{ 'coordinates' => [0.1, 1] }]
      )

      described_class.new(opportunity).persist!
      expect(Csv::CourseLookup.first).to have_attributes(
        subject: 'english',
        addressable: opportunity.venue,
        hours: 'study mode',
        delivery_type: 'attendance mode',
        postcode: opportunity.venue.postcode,
        latitude: 0.1,
        longitude: 1,
        opportunity: opportunity
      )
    end

    it 'sets addressable as venue if venue exists' do
      opportunity = create(
        :opportunity,
        study_modes: 'study mode',
        attendance_modes: 'attendance mode',
        course: create(:csv_course, name: 'english'),
        venue: create(:venue, postcode: 'L1 0BG')
      )

      described_class.new(opportunity).persist!

      expect(Csv::CourseLookup.first.addressable).to eq(opportunity.venue)
    end

    it 'sets addressable as provider if opportunity has no venue' do
      opportunity = create(
        :opportunity,
        study_modes: 'study mode',
        attendance_modes: 'attendance mode',
        course: create(:csv_course, name: 'english'),
        venue: nil
      )

      described_class.new(opportunity).persist!

      expect(Csv::CourseLookup.first.addressable).to eq(opportunity.course.provider)
    end

    it 'sets postcode from venue if venue exists' do
      opportunity = create(
        :opportunity,
        study_modes: 'study mode',
        attendance_modes: 'attendance mode',
        course: create(:csv_course, name: 'english'),
        venue: create(:venue, postcode: 'L1 0BG')
      )

      described_class.new(opportunity).persist!

      expect(Csv::CourseLookup.first.postcode).to eq('L1 0BG')
    end

    it 'sets postcode from provider if opportunity has no venue' do
      opportunity = create(
        :opportunity,
        study_modes: 'study mode',
        attendance_modes: 'attendance mode',
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
    end
  end
end
