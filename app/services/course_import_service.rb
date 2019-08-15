class CourseImportService
  COLUMN_HEADINGS = {
    title: 'title',
    provider: 'provider',
    url: 'url (course url)',
    address_line_1: 'address line 1',
    address_line_2: 'address line 2 (optional)',
    town: 'town',
    county: 'county',
    postcode: 'postcode',
    topic: 'type (Maths / English)',
    phone_number: 'tel',
    active: 'active'
  }.freeze

  attr_reader :errors

  def initialize
    not_production!
    @errors = []
  end

  def import(filename)
    file = Roo::Spreadsheet.open(filename)
    file.sheets.each do |name|
      sheet = file.sheet(name)

      sheet.each(COLUMN_HEADINGS) do |data|
        next if data == COLUMN_HEADINGS

        create_course(data)
      end
    end
  end

  def import_stats
    {
      courses_total: Course.count,
      courses_with_geocoding: Course.geocoded.count,
      courses_without_geocoding: courses_without_geocoding.count,
      errors: @errors.count
    }
  end

  def courses_without_geocoding
    Course.not_geocoded
  end

  private

  def create_course(data)
    # Cleanup data format
    data.each { |_key, value| value&.strip! }
    data[:active] = data[:active]&.downcase == 'yes'
    data[:topic]&.downcase!

    course = Course.new(data)
    @errors << course.errors unless course.save
  end

  def not_production!
    raise 'Not to be run in production' if Rails.env.production?
  end
end
