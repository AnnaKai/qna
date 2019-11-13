FactoryBot.define do
  factory :reward do
    name { "MyReward" }
    association :question
    association :user

    before :create do |reward|
      file = fixture_file_upload("#{Rails.root}/spec/fixtures/images/reward.jpg")
      reward.image.attach(file)
    end

  end
end
