require 'rails_helper'

feature 'User can add links to questions', %q{
  In order to provide additional info to my question
  As an author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:url) { 'https://www.meowingtons.com/blogs/lolcats/paws-jelly-beans' }

  scenario 'user adds link when asking a question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'my link'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'my link', href: url
  end

end