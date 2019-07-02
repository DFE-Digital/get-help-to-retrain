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

    trait :with_html_content do
      template = Rails.root.join('spec', 'fixtures', 'files', 'job_profile_content.html.erb').read

      content { ERB.new(template).result(binding) }
    end
  end
end
