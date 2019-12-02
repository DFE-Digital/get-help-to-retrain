FactoryBot.define do
  factory :feedback_survey do
    page_useful { true }
    url { 'https://some-url.com' }
  end
end
