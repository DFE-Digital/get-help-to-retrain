FactoryBot.define do
  factory :course_lookup, class: Csv::CourseLookup do
    opportunity { create(:opportunity) }
    addressable { [create(:venue), create(:provider)].sample }
    hours { ['full time', 'part time', 'flexible'].sample }
    delivery_type { ['online', 'work based', 'distance learning'].sample }
    postcode { ['NW11 8QE', 'NW11 7PT', 'NW11 7HB', 'NW10 7SF', 'NW10 7NZ', 'NW10 6HJ'].sample }
    subject { %w[maths esol english].sample }
  end
end
