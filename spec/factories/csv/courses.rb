FactoryBot.define do
  factory :csv_course, class: Csv::Course do
    provider { create(:provider) }
    name { Faker::Educator.course_name }
    external_course_id { Faker::Number.number(digits: 10) }
    qualification_name { Faker::Lorem.sentence }
    qualification_type { Faker::Lorem.sentence }
    qualification_level { %w[LV0 LV1 LV2 LV3 LVNA].sample }
    description { Faker::Company.catch_phrase }
    url { Faker::Internet.url }
    booking_url { Faker::Internet.url }
  end
end
