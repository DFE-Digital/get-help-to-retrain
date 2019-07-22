FactoryBot.define do
  factory :course do
    title { Faker::Educator.course_name }
    provider { Faker::Educator.university }
    url { 'http://example.com/' }
    address_line_1 { Faker::Address.street_name }
    address_line_2 { Faker::Address.street_address }
    town { Faker::Address.city }
    county { Faker::Address.state }
    postcode { ['EC1A 1AA', 'EC1A 1JJ', 'EC1A 1JN', 'EC1A 2AH', 'EC1P 1AB', 'EC1P 1EW', 'EC1P 1NY'].sample }
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
