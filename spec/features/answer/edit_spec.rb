require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of an answer
  I'd like to be able to edit the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 2, question: question, author: user) }

  scenario 'Unauthenticated user can not edit answers' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(answers.first.author)
      visit question_path(question)

      find(".edit-answer-link[data-answer-id=\"#{answers.first.id}\"]").click

      within '.answers' do
        fill_in 'Your corrected answer', with: 'new edited answer'
        click_on 'Submit'

        expect(page).to have_content answers.second.body
        expect(page).to have_content 'new edited answer'
        expect(page).to_not have_content answers.first.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    context 'edits an answer with attached files', js: true do
      background do
        sign_in(answers.first.author)
        visit question_path(question)

        find(".edit-answer-link[data-answer-id=\"#{answers.first.id}\"]").click

        within '.answers' do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Submit'
        end
      end

      scenario 'adds multiple files at once', js: true do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'adds more files without replacing already attached' do
        find(".edit-answer-link[data-answer-id=\"#{answers.first.id}\"]").click

        within '.answers' do
          attach_file 'Files', ["#{Rails.root}/public/404.html"]
          click_on 'Submit'
        end

        expect(page).to have_link '404.html'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'deletes attached files', js: true do
        within first('.file') do
          click_on 'Delete Attachment'
        end

        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario "not an author can't see attachments' links" do
      answer = create(:answer, files: [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")] )

      sign_in(create(:user))
      visit question_path(answer.question)

      within first('.file')  do
        expect(page).to_not have_link 'Delete'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in(answers.first.author)
      visit question_path(question)

      find(".edit-answer-link[data-answer-id=\"#{answers.first.id}\"]").click

      within '.answers' do
        fill_in 'Your corrected answer', with: ''
        click_on 'Submit'
        expect(page).to have_content answers.first.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content 'Body can\'t be blank'
    end

    scenario 'can not see the link to editing other users\' answers' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content 'Edit'
      end
    end
  end
end
