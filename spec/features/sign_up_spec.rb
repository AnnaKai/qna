require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an authenticated user
  I'd like to be able to sign up
} do

  scenario 'Unauthenticated user signs up' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: 'email@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'
    expect(page).to have_content 'Log out'
  end

  scenario 'Authenticated user sees no sign up link' do
    sign_in(create(:user))
    expect(page).not_to have_content 'Sign up'
    expect(page).to have_content 'Log out'
  end
end
