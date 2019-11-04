require 'rails_helper'

feature 'User can edit their question', %q{
  In order to correct mistakes
  As an author of the question
  I'd like to be able to edit the question
} do

  given(:not_author) { create(:user) }
  given(:question) { create(:question) }

  scenario 'unauthenticated user can not edit questions' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'authenticated user' do
    scenario 'author edits their question', js: true do
      sign_in(question.author)
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'new question title'
        fill_in 'Body', with: 'new question body text'
        click_on 'Update'

        expect(page).to have_content 'new question body text'
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    context 'author edits their question with attached files', js: true do
      background do
        sign_in(question.author)
        visit question_path(question)

        within '.question' do
          click_on 'Edit'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Update'
        end
      end

      scenario 'adds files' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'deletes files', js: true do
        within('.question') do
          first('.file').click_on 'Delete Attachment'
        end

        expect(page).to_not have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'author edits their question with errors', js: true do
    sign_in(question.author)
    visit question_path(question)

    within '.question' do
      click_on 'Edit'
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Update'
      expect(page).to have_content question.body
      expect(page).to have_selector 'textarea'
    end
    expect(page).to have_content 'Title can\'t be blank'
    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'not an author can not edit other users\' questions' do
    sign_in(not_author)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_content 'Edit'
    end
  end
end

