require 'rails_helper'

feature 'User can answer questions', %q{
  In order to answer a question
  As an authenticated user
  I'd like to post an answer from question's page
} do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'posts an answer to the question' do
      sign_in(create(:user))
      visit question_path(question)
      fill_in 'Your answer', with: 'Test answer'
      click_on 'Submit'
      expect(page).to have_content 'Your answer has been successfully created.'
      expect(page).to have_content 'Test answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'sees a warning message instead of an answer form' do
      visit question_path(question)
      expect(page).not_to have_content 'Your answer'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

end
