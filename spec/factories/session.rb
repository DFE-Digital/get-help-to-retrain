FactoryBot.define do
  factory :session do
    session_id { Faker::Alphanumeric.alpha }
    data { {} }
  end
end
