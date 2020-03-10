class CsvCoursesConstraint
  def matches?(_request)
    Flipflop.csv_courses?
  end
end
