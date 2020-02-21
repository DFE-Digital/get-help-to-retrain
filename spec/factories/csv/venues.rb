FactoryBot.define do
  factory :venue, class: Csv::Venue do
    name { Faker::Educator.campus }
    provider { create(:provider) }
  end
end
