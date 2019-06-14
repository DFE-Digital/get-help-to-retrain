FactoryBot.define do
  factory :category do
    name { Faker::Job.field }

    sequence :slug do |n|
      "#{name.underscore}_#{n}"
    end
  end
end
