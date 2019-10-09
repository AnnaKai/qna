require 'rails_helper'

feature 'User can answer questions', %q{
  In order to answer a question
  As an authenticated user
  I'd like to post an answer from question's page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, id: user.id) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'posts several answers to the question', js: true do
      2.times do
        fill_in 'Answer', with: 'Test answer'
        click_on 'Submit'
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'posts an answer and gets errors', js: true do
      click_on 'Submit'
      expect(page).to have_content 'Body can\'t be blank'
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
