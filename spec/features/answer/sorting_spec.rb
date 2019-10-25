require 'rails_helper'

feature 'User sees the best answer', %q{
  In order to see the most helpful answer
  As any user
  I visit the question's page
} do

  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 3, question: question) }

  context 'user' do
    scenario 'sees the best answer on top' do
      answers.third.best!
      visit question_path(question)
      within first(".answer") do
        expect(page).to have_content answers.third.body
        expect(page).to have_content 'The best answer'
      end
    end
  end
end
