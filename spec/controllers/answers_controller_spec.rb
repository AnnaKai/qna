require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  include_examples 'voted controller'

  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:body) { Faker::Lorem.paragraph }
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }

    context 'authenticated user' do
      let!(:user) { create(:user) }
      before { sign_in(user) }

      context 'with valid attributes' do
        it 'uploads the file' do
          expect { post :create, params: { question_id: question.id, answer: { body: body, files: [file] } }, format: :js }.to change{ ActiveStorage::Attachment.count }.by(1)
        end

        it 'saves a new answer in the db' do
          expect { post :create, params: { question_id: question.id, answer: { body: body } }, format: :js }.to change { question.answers.count }.by(1)
        end

        it 'saved answer has correct author value' do
          post :create, params: { question_id: question.id, answer: { body: body } }, format: :js
          expect(question.answers.last).to have_attributes(body: body, author: user)
        end

        it 'redirects to show view' do
          post :create, params: { question_id: question.id, answer: { body: body } }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question.id, answer: { body: nil } }, format: :js }.to_not change { Answer.count }
        end

        it 're-renders question view' do
          post :create, params: { question_id: question.id, answer: { body: nil } }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save an answer' do
        expect { post :create, params: { question_id: question.id, answer: { body: body } }, format: :js }.to_not change { Answer.count }
      end

      it 'gets asked to authorize' do
        post :create, params: { question_id: question.id, answer: { body: body } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let(:new_body) { Faker::Lorem.paragraph }
    let(:not_author) { create(:user) }
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }

    context 'authenticated user' do
      context 'author' do
        before { login(answer.author) }

        context 'with valid attributes' do
          it 'should upload the file' do
            expect { patch :update, params: { id: answer, answer: { body: new_body, files: [file] } }, format: :js }.to change{ ActiveStorage::Attachment.count }.by(1)
          end

          it 'changes answer attributes' do
            patch :update, params: { id: answer, answer: { body: new_body} , format: :js }
            answer.reload
            expect(answer.body).to eq new_body
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: { body: new_body }, format: :js }
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          it 'does not change answer' do
            expect do
              patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
              answer.reload
            end.to_not change { answer.body }
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
            expect(response).to render_template :update
          end
        end
      end

      context 'not an author' do
        before { login(not_author) }

        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: { body: new_body }, format: :js }
            answer.reload
          end.to_not change { answer.body }
        end
      end
    end

    context 'unauthenticated user' do
      it 'gets asked to authorize' do
        patch :update, params: { id: answer, answer: { body: new_body }, format: :js }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: { body: new_body }, format: :js }
          answer.reload
        end.to_not change { answer.body }
      end
    end
  end

  describe 'PATCH #best' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:not_author) { create(:user) }

    context 'authenticated' do
      context 'author' do
        before { login(question.author) }

        it 'marks answer as best' do
          patch :best, params: { question_id: question, id: answer }, format: :js
          answer.reload
          expect(answer).to be_best
        end
      end

      context 'not an author' do
        before { login(not_author) }

        it 'cannot mark the answer as best' do
          patch :best, params: { question_id: question, id: answer }, format: :js
          answer.reload
          expect(answer).to_not be_best
        end
      end
    end

    context 'unauthenticated' do
      it 'cannot mark the answer as best' do
        patch :best, params: { question_id: question, id: answer }, format: :js
        answer.reload
        expect(answer).to_not be_best
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
          expect { delete :destroy, params: { question_id: question.id, id: answer.id }, format: :js }.to_not change(Answer, :count)
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
