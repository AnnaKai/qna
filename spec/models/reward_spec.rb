require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional }

  it { should validate_presence_of :name }

  it 'have one attached image' do
    expect(Reward.new.image).to be_an_instance_of ActiveStorage::Attached::One
  end

  it 'is invalid when image has wrong file extension' do
    reward = Reward.create(image: fixture_file_upload("#{Rails.root}/spec/rails_helper.rb"))
    expect(reward.errors[:image]).to include('wrong file extension')
  end

  it 'is valid when attachment has a valid file extension' do
    reward = create(:reward)
    expect(reward).to be_valid
  end

end
