FactoryBot.define do
  factory :opportunity, class: Csv::Opportunity do
    venue { create(:venue) }
    course { create(:csv_course) }
    external_opportunities_id { Faker::Number.number(digits: 10) }
    attendance_modes { ['Location / campus', 'Work-based', 'Mixed Mode'].sample }
    attendance_pattern { %w[Evening Weekend Customised].sample }
    study_modes { ['full time', 'part time', 'flexible'].sample }
    end_date { Faker::Date.forward(days: 90) }
    duration_value { Faker::Types.rb_integer }
    duration_type { %w[Hours Days Month].sample }
    duration_description { Faker::Company.catch_phrase }
    start_date_description { Faker::Company.catch_phrase }
    price { Faker::Commerce.price }
    price_description { Faker::Lorem.sentence }
    url { Faker::Internet.url }
  end
end
