require 'rails_helper'

feature 'User sees the best answer', %q{
  In order to see the most helpful answer
  As any user
  I visit the question's page
} do

  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }
  given!(:best_answer) { create(:answer, question: question, best: true) }

  context 'user' do
    scenario 'sees the best answer on top' do
      visit question_path(question)
      within first(".answer") do
        expect(page).to have_content best_answer.body
        expect(page).to have_content 'The best answer'
      end
    end
  end
end
