FactoryBot.define do
  factory :course_detail, class: Csv::CourseDetail do
    name { Faker::Educator.course_name }
    provider { create(:provider) }
  end
end
