FactoryBot.define do
  factory :answer do
    association :author, factory: :user
    body { "MyAnswerText" }
  end
end
