FactoryBot.define do
  factory :admin_role do
    name { %w[management readwrite read].sample }
    display_name { Faker::Name.name.downcase }
    resource_id { SecureRandom.uuid }
  end
end
