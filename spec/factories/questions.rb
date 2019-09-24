FactoryBot.define do
  factory :question do
    association :author, factory: :user
    title { Faker::TvShows::RickAndMorty.quote }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
