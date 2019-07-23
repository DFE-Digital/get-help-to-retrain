FactoryBot.define do
  factory :course do
    title { Faker::Educator.course_name }
    provider { Faker::Educator.university }
    url { 'http://example.com/' }
    address_line_1 { Faker::Address.street_name }
    address_line_2 { Faker::Address.street_address }
    town { Faker::Address.city }
    county { Faker::Address.state }
    postcode { ['NW11 8QE', 'NW11 7PT', 'NW11 7HB', 'NW10 7SF', 'NW10 7NZ', 'NW10 6HJ'].sample }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    active { false }
    topic { Faker::Educator.subject }

    trait :enabled do
      active { true }
    end

    trait :maths do
      topic { 'maths' }
    end

    trait :english do
      topic { 'english' }
    end
  end
end
