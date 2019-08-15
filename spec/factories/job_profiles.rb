FactoryBot.define do
  factory :job_profile do
    name { Faker::Job.title }
    description { Faker::Company.catch_phrase }
    content { Faker::Lorem.paragraphs.join }
    recommended { true }

    sequence :slug do |n|
      "#{name.parameterize.underscore}_#{n}"
    end

    trait :excluded do
      recommended { false }
    end

    trait :falling do
      growth { -7.45 }
    end

    trait :stable do
      growth { 4.56 }
    end

    trait :growing do
      growth { 9.89 }
    end

    trait :growing_strongly do
      growth { 51.22 }
    end

    trait :with_html_content do
      template = Rails.root.join('spec', 'fixtures', 'files', 'job_profile_content.html.erb').read

      content { ERB.new(template).result(binding) }
    end
  end
end
