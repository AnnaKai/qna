require 'rails_helper'

feature 'User can remove their questions', %q{
  In order to delete my own questions
  As an authenticated user
  I visit the question's page
} do

  given(:questions) { create_list(:question, 2) }

  context 'Authenticated user' do
    scenario 'Author deletes their question' do
      sign_in(questions.first.author)
      visit question_path(questions.first)
      click_on 'Delete question'
      expect(page).to have_content 'You have successfully deleted your question'
      visit questions_path
      expect(page).not_to have_content questions.first.title
      expect(page).to have_content questions.last.title
    end

    scenario 'User can not delete someone else\'s question' do
      sign_in(create(:user))
      visit question_path(questions.first)
      expect(page).not_to have_link 'Delete question'
    end
  end

  context 'Unauthenticated user' do
    scenario 'can not delete questions' do
      visit question_path(questions.first)
      expect(page).not_to have_link 'Delete answer'
    end
  end
end
