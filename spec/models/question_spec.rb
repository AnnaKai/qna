require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :author }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#sorted_answers' do
    it 'the best answer is the first' do
      question = create(:question)
      answer = create(:answer, question: question)
      best_answer = create(:answer, question: question)
      question.update(best_answer_id: best_answer.id)

      expect(question.sorted_answers.all.to_a).to eq([best_answer, answer])
    end
  end
end
