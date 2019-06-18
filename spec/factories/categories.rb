FactoryBot.define do
  factory :category do
    name { Faker::Job.field }

    sequence :slug do |n|
      "#{name.parameterize.underscore}_#{n}"
    end
  end
end
