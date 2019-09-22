FactoryBot.define do
  factory :question do
    title { Faker::TvShows::RickAndMorty.quote }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
