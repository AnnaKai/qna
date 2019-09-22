require 'rails_helper'

feature 'User can answer questions', %q{
  In order to answer a question
  As an authenticated user
  I'd like to post an answer from question's page
} do

  describe 'Authenticated user' do
    scenario 'posts an answer to the question' do
      question = create(:question)
      visit question_path(question)
      fill_in 'Your answer', with: 'Test answer'
      click_on 'Submit'
      expect(page).to have_content 'Your answer has been successfully created.'
      expect(page).to have_content 'Test answer'
    end
  end

  describe 'Unauthenticated user' do

  end

end
