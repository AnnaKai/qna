FactoryBot.define do
  factory :answer do
    association :author, factory: :user
    question
    body { 'MyAnswerText' }
  end
end
