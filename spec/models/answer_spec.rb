require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }

  it { should validate_presence_of :body }

  describe '#best' do
    it 'returns true if answer is the best' do
      question = create(:question)
      best_answer = create(:answer, question: question)
      answer = create(:answer, question: question)
      question.update(best_answer_id: best_answer.id)
      expect(best_answer.best?).to eq(true)
      expect(answer.best?).to eq(false)
    end
  end
end
