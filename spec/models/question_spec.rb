require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :author }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#answers' do
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer, 3, question: question) }

    it 'the best answer is the first' do
      question.update(best_answer_id: answers.second.id)
      expect(question.answers.all.to_a).to eq([answers.second, answers.first, answers.last])
    end
  end
end
