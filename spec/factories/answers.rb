FactoryBot.define do
  factory :answer do
    association :author, factory: :user
    question
    body { Faker::Lorem.paragraph }

    trait :invalid do
      body { nil }
    end
  end
end
