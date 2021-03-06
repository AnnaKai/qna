require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

 describe 'DELETE #destroy' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    let(:question) { create(:question, files: [file]) }

    context 'authenticated user' do
      before { login(question.author) }

      context 'is author' do
        it 'deletes attached file' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js}.to change(question.files, :count).by(-1)
        end

        it 'renders destroy view', js: true do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'is not an author' do
        before { login(create(:user)) }

        it 'deletes a file of the resource' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
        end

        it 'redirects to question', js: true do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

   context 'unauthenticated user' do
     it 'can not delete attached files' do
       expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
     end

     it 'render destroy' do
       delete :destroy, params: { id: question.files.first }, format: :js
       expect(response).to have_http_status(401)
     end
   end
  end
end
