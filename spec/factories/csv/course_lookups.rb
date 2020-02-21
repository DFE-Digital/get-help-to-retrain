FactoryBot.define do
  factory :course_lookup, class: Csv::Course do
    course_detail { create(:course_detail) }
    addressable { create(:venue) }
  end
end
