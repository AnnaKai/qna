require 'rails_helper'

feature 'User can edit question links', %q(
  In order to correct mistakes
  As a question's author
  I would like to be able to edit links
) do

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question, author: user) }
    given!(:link) { create(:link, linkable: question) }

    scenario 'edits a link' do
      sign_in(question.author)
      visit question_path(question)

      expect(page).to have_link 'Link_name', href: 'Link_url'

      within '.question' do
        click_on 'Edit'

        fill_in 'Link name',  with: 'New link name'
        fill_in 'Url',  with: 'http://new_url.com'
      end

      click_on 'Update'
      expect(page).to have_link 'New link name', href: 'http://new_url.com'
    end
  end
end