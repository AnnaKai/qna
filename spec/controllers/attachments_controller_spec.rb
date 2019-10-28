require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    before { login(user) }
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    let(:question) { create(:question, user: user, files: [file]) }

    context 'authenticated user' do
      context 'is author' do
        it 'deletes attached files' do

        end

        it 'renders destroy view' do

        end
      end

      context 'is not an author' do

      end
    end
  end
end
