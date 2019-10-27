require 'rails_helper'

feature 'User can create question', %q{
  In order to get answers from community
  As an unauthenticated user
  I'd like to be able to ask a question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test test test'

      click_on 'Ask'
      expect(page).to have_content 'Your question has been successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'test test test'

    end

    scenario 'asks a question and gets errors' do
      click_on 'Ask'
      expect(page).to have_content 'Title can\'t be blank'
    end

    scenario 'ask a question with an attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test test test'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Ask'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
