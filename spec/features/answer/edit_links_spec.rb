require 'rails_helper'

feature 'User can edit answer\'s links', %q{
  In order to correct invalid links
  As an author
  I'd like to be able to edit links
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer, author: user) }
  given!(:link) { create(:link, linkable: answer) }
  given(:url) { 'https://www.meowingtons.com/blogs/lolcats/paws-jelly-beans' }

  scenario 'user corrects a link when editing an answer', js: true do
    sign_in(answer.author)

    visit question_path(answer.question)

    within first('.answer') do
      click_on 'Edit'

      fill_in 'Link name',	with: 'Edited link'
      fill_in 'Url',	with: url

      click_on 'Submit'
    end

    expect(page).to have_link 'Edited link', href: url
  end
end
