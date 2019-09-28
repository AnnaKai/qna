require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:body) { Faker::Lorem.paragraph }

    context 'authenticated user' do
      let(:user) { create(:user) }
      before { sign_in(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the db' do
          expect { post :create, params: { question_id: question.id, body: body } }.to change { question.answers.count }.by(1)
        end

        it 'saved answer has correct values' do
          post :create, params: { question_id: question.id, body: body }
          expect(Answer.last).to have_attributes(body: body, user_id: user.id)
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
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'unauthenticated user' do
      before { post :create, params: { question_id: question.id, body: body } }

      it 'does not save an answer' do
        expect(Answer.count).to eq(0)
      end

      it 'gets asked to authorize' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
