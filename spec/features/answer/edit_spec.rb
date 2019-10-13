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

      find("[data-answer-id=\"#{answers.first.id}\"]").click

      within '.answers' do
        fill_in 'Your corrected answer', with: 'new edited answer'
        click_on 'Submit'

        expect(page).to have_content answers.second.body
        expect(page).to have_content 'new edited answer'
        expect(page).to_not have_content answers.first.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do

    end

    scenario 'tries to edit other users\' answers' do

    end
  end
end
