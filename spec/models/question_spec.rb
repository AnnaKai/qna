require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :author }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#answers' do
    it 'the best answer is the first' do
      question = create(:question)
      answer = create_list(:answer, 3, question: question)
      question.update(best_answer_id: answer.second.id)

      expect(question.answers.all.to_a).to eq([answer.second, answer.first, answer.last])
    end
  end
end
