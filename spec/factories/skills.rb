FactoryBot.define do
  factory :skill do
    sequence :name do |n|
      "#{Faker::Job.key_skill}_#{n}"
    end
  end
end
