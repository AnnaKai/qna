require 'rails_helper'

feature 'User can sign out', %q{
  In order to switch accounts or secure account
  As an authenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign out' do
    sign_in(user)
    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(page).not_to have_content 'Log out'
    expect(page).to have_content 'Log in'
  end

  scenario 'Unauthenticated user sees no log out link' do
    visit root_path
    expect(page).not_to have_content 'Log out'
    expect(page).to have_content 'Log in'
  end
end
