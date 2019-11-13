FactoryBot.define do
  factory :question do
    association :author, factory: :user
    title { Faker::TvShows::RickAndMorty.quote }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    trait :with_reward do
      reward { create(:reward) }
    end
  end
end
