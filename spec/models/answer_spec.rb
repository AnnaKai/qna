require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }

  it { should validate_presence_of :body }

  describe '#best?' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:best_answer) do
      create(:answer, question: question).tap { |a| question.update!(best_answer_id: a.id) }
    end

    it 'returns true if answer is the best' do
      expect(best_answer).to be_best
      expect(answer).not_to be_best
    end
  end
end
