FactoryBot.define do
  factory :job_profile do
    name { Faker::Job.title }
    description { Faker::Company.catch_phrase }
    content { Faker::Lorem.paragraphs }

    sequence :slug do |n|
      "#{name.underscore}_#{n}"
    end

    trait :recommended do
      recommended { true }
    end
  end
end
