require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to view all questions
  As any user
  I visit the main page
} do
  given!(:questions) { create_list(:question, 2) }

  background { visit root_path }

  scenario 'gets a list of questions' do
    questions.each { |q| expect(page).to have_content(q.title) }
  end

  scenario 'clicks on a question title to see the question details' do
    question = questions.sample
    click_on question.title
    expect(page).to have_content(question.body)
  end
end

