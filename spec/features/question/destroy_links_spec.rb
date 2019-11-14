require 'rails_helper'

feature 'User can delete questions\' links', %q{
  In order to delete outdated links
  As an author
  I'd like to be able to delete them
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'author deletes question\'s links', js: true do
    sign_in(question.author)
    visit question_path(question)

    expect(page).to have_link link.name, href: link.url

    within '.question' do
      click_on 'Edit'
      within first('.link-fields') do
        click_on 'Remove link'
      end
      click_on 'Update'
    end

    expect(page).to_not have_link link.name, href: link.url
  end

end