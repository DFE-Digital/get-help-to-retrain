FactoryBot.define do
  factory :opportunity, class: Csv::Opportunity do
    venue { create(:venue) }
    course_detail { create(:course_detail) }
  end
end
