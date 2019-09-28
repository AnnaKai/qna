require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'question author' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    it 'user is the author' do
      expect(user).to be_author_of(question)
    end

    it 'user is not the author' do
      expect(create(:user)).not_to be_author_of(question)
    end
  end

  describe 'answer author' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question_id: question.id, author: user) }

    it 'user is the author' do
      expect(user).to be_author_of(answer)
    end

    it 'user is not the author' do
      expect(create(:user)).not_to be_author_of(answer)
    end
  end
end
