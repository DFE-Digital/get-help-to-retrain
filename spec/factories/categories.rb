FactoryBot.define do
  factory :category do
    name { Faker::Job.field }

    sequence :slug do |n|
      "#{name.parameterize.underscore}_#{n}"
    end

    trait :with_job_profile do
      after(:create) do |category|
        create(:job_profile, categories: [category])
      end
    end
  end
end
