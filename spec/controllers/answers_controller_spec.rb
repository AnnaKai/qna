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
          expect { post :create, params: { question_id: question.id, body: body }, format: :js }.to change { question.answers.count }.by(1)
        end

        it 'saved answer has correct values including an author' do
          post :create, params: { question_id: question.id, body: body }, format: :js
          expect(Answer.last).to have_attributes(body: body, user_id: user.id)
        end

        it 'redirects to show view' do
          post :create, params: { question_id: question.id, body: body }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question.id, body: nil }, format: :js }.to_not change { Answer.count }
        end

        it 're-renders question view' do
          post :create, params: { question_id: question.id, body: nil }, format: :js
          expect(response).to render_template :create
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

  describe 'PATCH #update' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let(:body) { Faker::Lorem.paragraph }
    let(:user) { create(:user) }

    context 'authenticated user' do
      context 'author' do
        before { login(answer.author) }

        context 'with valid attributes' do
          it 'changes answer attributes' do
            patch :update, params: { id: answer, answer: { body: body }, format: :js }
            answer.reload
            expect(answer.body).to eq body
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: { body: 'New body' }, format: :js }
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          it 'does not change answer attributes' do
            expect do
              patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
            end.to_not change(answer, :body)
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
            expect(response).to render_template :update
          end
        end
      end

      context 'not an author' do
        before { login(user) }

        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: { body: body }, format: :js }
          end.to_not change(answer, :body)
        end

        it 'sees forbidden error' do
          patch :update, params: { id: answer, answer: { body: body }, format: :js }
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'unauthenticated user' do
      it 'gets asked to authorize' do
        patch :update, params: { id: answer, answer: { body: body }, format: :js }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, author: user) }
    let(:user) { create(:user) }

    context 'authenticated' do
      context 'author' do
        before { sign_in(user) }

        it 'deletes their answer in the db' do
          expect { delete :destroy, params: { question_id: question.id, id: answer.id, format: :js } }.to change(Answer, :count).by(-1)
        end

      end

      context 'not an author' do
        before { sign_in(create(:user)) }

        it 'does not delete the answer' do
          expect { delete :destroy, params: { question_id: question.id, id: answer.id } }.to_not change(Answer, :count)
        end

        it 're-renders the answer\'s question' do
          delete :destroy, params: { question_id: question.id, id: answer.id }
          expect(response).to redirect_to question
        end
      end
    end

    context 'unauthenticated' do
      before { delete :destroy, params: { question_id: question.id, id: answer.id } }

      it 'gets asked to authorize' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
