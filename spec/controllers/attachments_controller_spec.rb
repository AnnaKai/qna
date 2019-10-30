require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

 describe 'DELETE #destroy' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    let(:question) { create(:question, files: [file]) }

    context 'authenticated user' do
      before { login(question.author) }

      context 'is author' do
        it 'deletes attached files' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js}.to change(question.files, :count).by(-1)
        end

        it 'renders destroy view' do

        end
      end

      context 'is not an author' do

      end
    end
  end
end
