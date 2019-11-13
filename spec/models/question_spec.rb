require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should belong_to :author }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:reward) { create(:reward, user: user) }
  let!(:question) { create(:question, author: user, reward: reward) }

  it 'sets reward' do
    question.set_reward!(another_user)

    expect(question.reward.user).to eq another_user
  end
end
