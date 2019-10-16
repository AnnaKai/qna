require 'rails_helper'

feature 'User chooses the best answer', %q{
  In order to mark the most helpful answer
  As an author of the question
  I'd like to be able to choose one answer
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  context 'authenticated user' do
    context 'author' do
      scenario 'selects and saves the best answer', js: true do
        sign_in(question.author)
        visit question_path(question)

        find(".choose-answer[data-answer-id=\"#{answers.second.id}\"]").click

        within "#answer-#{answers.second.id}" do
          expect(page).to have_content 'The best answer'
          expect(page).to_not have_content 'Mark as best'
        end

        visit question_path(question)

        within "#answer-#{answers.second.id}" do
          expect(page).to have_content 'The best answer'
          expect(page).to_not have_content 'Mark as best'
        end
      end
    end

    context 'not an author' do
    end
  end

  context 'unauthenicated user' do
    scenario 'sees the best answer' do
      question.update!(best_answer: answers.first)
      visit question_path(question)
      expect(page).to have_content 'The best answer'
    end
  end
end
