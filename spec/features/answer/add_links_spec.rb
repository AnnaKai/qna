require 'rails_helper'

feature 'User can add links to answers', %q{
  In order to provide additional info to my answer
  As an author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:url) { 'https://www.meowingtons.com/blogs/lolcats/paws-jelly-beans' }

  scenario 'user adds link when posting an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Answer', with: 'Test answer'

    fill_in 'Link name', with: 'my link'
    fill_in 'Url', with: url

    click_on 'Submit'

    within '.answers' do
      expect(page).to have_link 'my link', href: url
    end
  end
end