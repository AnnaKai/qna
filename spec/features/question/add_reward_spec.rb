require 'rails_helper'

feature 'User can add reward to their question', %q(
  In order to mark the best answer
  As a question's author
  I'd like to be able to add reward
) do

  describe 'authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'question title'
      fill_in 'Body', with: 'question body'
    end

    scenario 'adds reward successfully' do
      within '.reward' do
        fill_in 'Reward Title', with: 'Reward Name'
        attach_file 'Image', "#{Rails.root}/spec/fixtures/images/reward.jpg"
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question has been successfully created'
      expect(page.find('.reward')['src']).to have_content 'reward.jpg'
    end

    scenario 'adds invalid reward name without an image' do
      within '.reward' do
        fill_in 'Reward Title', with: 'Reward Name'
      end

      click_on 'Ask'

      expect(page).to have_content "Reward image can't be blank"
    end

    scenario 'adds an image without reward name' do
      within '.reward' do
        attach_file 'Image', "#{Rails.root}/spec/fixtures/images/reward.jpg"
      end

      click_on 'Ask'

      expect(page).to have_content "Reward name can't be blank"
    end

    scenario 'adds invalid file' do
      within '.reward' do
        fill_in 'Reward Title', with: 'Reward Name'
        attach_file 'Image', "#{Rails.root}/spec/spec_helper.rb"
      end

      click_on 'Ask'

      expect(page).to have_content 'wrong file extension'
    end
  end
end
