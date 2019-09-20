require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:body) { Faker::Lorem.paragraph }

    context 'with valid attributes' do
      it 'saves a new answer in the db' do
        expect { post :create, params: { question_id: question.id, body: body } }.to change { question.answers.count }.by(1)
        expect(Answer.last).to have_attributes(question_id: question.id, body: body)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question.id, body: body }
        expect(response).to redirect_to(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id, body: nil } }.to_not change { Answer.count }
      end
      it 're-renders question view' do
        post :create, params: { question_id: question.id, body: nil }
        expect(response).to render_template :new
      end
    end
  end
end
