FactoryBot.define do
  factory :feedback_survey do
    page_useful { true }
    url { 'https://some-url.com' }

    trait :with_message do
      message { Faker::Movies::HarryPotter.quote }
    end
  end
end
