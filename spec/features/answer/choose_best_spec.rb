require 'rails_helper'

feature 'User chooses the best answer', %q{
  In order to mark the most helpful answer
  As an author of the question
  I'd like to be able to choose one answer
} do

  context 'authenticated user' do
    context 'author' do
      scenario 'selects the best answer', js: true do
        question = create(:question)
        answers = create_list(:answer, 3, question: question)
        sign_in(question.author)
        visit question_path(question)

        find(".choose-answer[data-answer-id=\"#{answers.second.id}\"]").click

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
  end
end
