require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to view all questions
  As any user
  I visit the main page
} do

  scenario 'gets a list of questions' do
    questions = create_list(:question, 2)
    visit root_path
    questions.each { |q| expect(page).to have_content(q.title) }
  end
end

