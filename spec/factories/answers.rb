FactoryBot.define do
  factory :answer do
    association :author, factory: :user
    question
    body { 'MyAnswerText' }

    trait :invalid do
      body { nil }
    end
  end
end
