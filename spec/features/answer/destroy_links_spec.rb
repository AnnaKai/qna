require 'rails_helper'

feature 'User can delete links', %q{
  In order to remove outdated links
  As an author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer, author: user) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'user deletes a link when editing an answer', js: true do
    sign_in(answer.author)

    visit question_path(answer.question)

    expect(page).to have_link link.name, href: link.url

    within first('.answer') do
      click_on 'Edit'
      
      within first('.link-fields') do
        click_on 'Remove link'
      end

      click_on 'Submit'
    end

    expect(page).to_not have_link link.name, href: link.url
  end
end
