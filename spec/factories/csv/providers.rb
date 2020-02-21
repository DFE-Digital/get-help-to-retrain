FactoryBot.define do
  factory :provider, class: Csv::Provider do
    name { Faker::Educator.university }
  end
end
