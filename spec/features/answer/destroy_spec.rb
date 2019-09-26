require 'rails_helper'

feature 'User can remove their answers', %q{
  In order to delete my own answers
  As an authenticated user
  I visit the question's page
} do
  given(:answer) { create(:answer) }
  given(:question) { answer.question }

  context 'Authenticated user' do
    scenario 'Author deletes their answer' do
      sign_in(answer.author)
      visit question_path(question)
      expect(page).to have_content answer.body
      click_on 'Delete answer'
      expect(page).to have_content 'You have successfully deleted your answer'
      expect(page).not_to have_content answer.body
    end

    scenario 'User can not delete someone else\'s answer' do
      sign_in(create(:user))
      visit question_path(question)
      expect(page).not_to have_link 'Delete answer'
    end
  end

  context 'Unauthenticated user' do
    scenario 'can not delete answers' do
      visit question_path(question)
      expect(page).not_to have_link 'Delete answer'
    end
  end
end
