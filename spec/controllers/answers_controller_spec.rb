require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      let(:question) { create(:question) }
      let(:body) { Faker::Lorem.paragraph }

      it 'saves a new answer in the db' do
        expect { post :create, params: { question_id: question.id, body: body } }.to change { Answer.count }.by(1)
        expect(Answer.last).to have_attributes(question_id: question.id, body: body)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question.id, body: body }
        expect(response).to redirect_to(question)
      end
    end
  end
end
