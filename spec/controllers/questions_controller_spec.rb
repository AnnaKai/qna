require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new link for an answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns links to question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(question.author) }
    before { get :edit, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        let(:question_form) { attributes_for(:question) }

        it 'saves a new question in the db' do
          expect { post :create, params: { question: question_form } }.to change(Question, :count).by(1)
        end

        it 'saved question has correct values including an author' do
          post :create, params: { question: question_form }
          expect(Question.last).to have_attributes(title: question_form[:title], body: question_form[:body], user_id: user.id)
        end

        it 'redirects to show view' do
          post :create, params: { question: question_form }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end
        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'unauthenticated user' do
      it 'can not post a question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'authenticated user' do
      context 'author' do
        before { login(question.author) }

        context 'with valid attributes' do
          it 'assings the requested question to @question' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(assigns(:question)).to eq question
          end

          it 'changes question attributes' do
            patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js }
            question.reload

            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it 'renders update view' do
            patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
            expect(response).to render_template :update
          end

        end

        context 'with invalid attributes' do

          it 'does not change question' do
            expect do
              patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
              question.reload
            end.to_not change { question.body }
          end

          it 'renders update view' do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
            expect(response).to render_template :update
          end
        end
      end

      context 'not an author' do
        before { login(user) }

        it 'does not change question attributes' do
          expect do
            patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
            question.reload
          end.to_not change { question.body }
        end
      end
    end

    context 'unauthenticated user' do
      it 'gets asked to authorize' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          question.reload
        end.to_not change { question.body }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }

    context 'authenticated' do
      context 'author' do
        before { login(question.author) }

        it 'deletes the question' do
          expect {delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: {id: question}
          expect(response).to redirect_to questions_path
        end
      end

      context 'not an author' do
        before { login(create(:user)) }

        it 'does not delete the question' do
          expect { delete :destroy, params: { id: question.id } }.not_to change(Question, :count)
        end

        it 're-renders the question' do
          delete :destroy, params: { id: question.id }
          expect(response).to redirect_to question
        end
      end
    end

    context 'unauthenticated user' do
      before { delete :destroy, params: { id: question } }

      it 'gets asked to authorize' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
