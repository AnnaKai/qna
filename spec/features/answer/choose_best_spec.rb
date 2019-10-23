require 'rails_helper'

feature 'User chooses the best answer', %q{
  In order to mark the most helpful answer
  As an author of the question
  I'd like to be able to choose one answer
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given(:user) { create(:user) }

  context 'authenticated user' do
    context 'author' do
      scenario 'selects and saves the best answer showing it on top', js: true do
        sign_in(question.author)
        visit question_path(question)

        find(".choose-answer[data-answer-id=\"#{answers.second.id}\"]").click

        within first(".answer") do
          expect(page).to have_content answers.second.body
          expect(page).to have_content 'The best answer'
          expect(page).to_not have_link 'Mark as best'
        end
      end
    end

    context 'not an author' do
      scenario 'can not select the best answer' do
        sign_in(user)
        visit question_path(question)
        expect(page).to_not have_content 'Mark as best'
      end
    end
  end
end
