require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }

  it { should validate_presence_of :body }

  describe 'best' do
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer, 3, question: question) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    it 'mark answer as the best' do
      answers.first.best!
      expect(answers.first).to be_best
    end

    it 'should not be the best' do
      expect(answers.first).not_to be_best
    end

    it 'the best should be the first' do
      answers.last.best!
      expect(Answer.all.to_a).to eq([answers.last, best_answer, answers.first, answers.second])
    end

    context 'only one answer is the best' do
      before { answers.first.best! }

      it { expect(best_answer.reload).to_not be_best }
      it { expect(answers.first.reload).to be_best }
    end
  end

end
