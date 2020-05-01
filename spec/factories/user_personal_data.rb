FactoryBot.define do
  factory :user_personal_data do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    postcode { ['NW11 8QE', 'NW11 7PT', 'NW11 7HB', 'NW10 7SF', 'NW10 7NZ', 'NW10 6HJ'].sample }
    gender { %w[male female not_mentioned].sample }
    dob { Faker::Date.between(from: 99.years.ago, to: 18.years.ago) }
    birth_day { 13 }
    birth_month { 1 }
    birth_year { DateTime.now.year - 18 }
  end
end
