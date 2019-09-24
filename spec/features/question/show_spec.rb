require 'rails_helper'

feature 'User can see a question and answers to it', %q{
  In order to see the question and its answers
  As any user
  I visit a question's page
} do

  scenario 'sees all the answers to the question' do
    question = create(:question)
    answers = create_list(:answer, 2, question: question)
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end

feature 'User can answer questions', %q{
  In order to answer a question
  As an authenticated user
  I'd like to post an answer from question's page
} do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(create(:user))
      visit question_path(question)
    end

    scenario 'posts an answer to the question' do
      fill_in 'Your answer', with: 'Test answer'
      click_on 'Submit'
      expect(page).to have_content 'Your answer has been successfully created.'
      expect(page).to have_content 'Test answer'
    end

    scenario 'posts an answer and gets errors' do
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
