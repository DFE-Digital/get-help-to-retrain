FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }
    resource_id { SecureRandom.uuid }
    name { Faker::Name.name.downcase.split.join('.') }
  end
end
