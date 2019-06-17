FactoryBot.define do
  factory :job_profile do
    name { Faker::Job.title }
    description { Faker::Company.catch_phrase }
    content { Faker::Lorem.paragraphs.join }

    sequence :slug do |n|
      "#{name.parameterize.underscore}_#{n}"
    end

    trait :recommended do
      recommended { true }
    end
  end
end
