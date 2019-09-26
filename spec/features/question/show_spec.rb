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
