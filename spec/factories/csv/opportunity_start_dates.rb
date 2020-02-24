FactoryBot.define do
  factory :opportunity_start_date, class: Csv::OpportunityStartDate do
    start_date { Faker::Date.forward(days: 30) }
    opportunity { create(:opportunity) }
  end
end
