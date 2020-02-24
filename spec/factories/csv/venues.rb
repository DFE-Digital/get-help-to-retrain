FactoryBot.define do
  factory :venue, class: Csv::Venue do
    external_venue_id { Faker::Number.number(digits: 10) }
    provider { create(:provider) }
    name { Faker::Educator.university }
    address_line_1 { Faker::Address.street_name }
    address_line_2 { Faker::Address.street_address }
    town { Faker::Address.city }
    county { Faker::Address.state }
    postcode { ['NW11 8QE', 'NW11 7PT', 'NW11 7HB', 'NW10 7SF', 'NW10 7NZ', 'NW10 6HJ'].sample }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    url { Faker::Internet.url }
  end
end
