require 'rails_helper'

feature 'User can vote for questions/answers', %q(
  In order to show that I like/dislike question/answer
  As an authenticated user
  I'd like to be able to increase/decrease its rating
) do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user', js: true do
    context 'voting for others\' questions' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'votes for the question they like' do
        expect(page.find('.rating')).to have_content '0'
        click_on 'Like'
        expect(page.find('.rating')).to have_content '1'
        visit question_path(question)
        expect(page.find('.rating')).to have_content '1'
      end

      scenario 'changes their vote' do
        within "#question-#{question.id}" do
          click_on 'Dislike'
          expect(page.find('.rating')).to have_content '-1'
          click_on 'Like'
          expect(page.find('.rating')).to have_content '0'
          click_on 'Like'
          expect(page.find('.rating')).to have_content '1'
        end
      end

      scenario 'dislikes a question' do
        within "#question-#{question.id}" do
          expect(page.find('.rating')).to have_content '0'
          click_on 'Dislike'
          expect(page.find('.rating')).to have_content '-1'
          visit question_path(question)
          expect(page.find('.rating')).to have_content '-1'
        end
      end

      scenario 'sees overall rating' do
        create_list(:vote, 3, user: create(:user), value: 1, votable: question)

        within "#question-#{question.id}" do
          click_on 'Like'
          expect(page.find('.rating')).to have_content '4'
        end
      end

      scenario 'tries to like/dislike twice without success' do
        within "#question-#{question.id}" do
          click_on 'Dislike'
          click_on 'Dislike'
        end
        text = page.driver.browser.switch_to.alert.text
        expect(text).to eq "You can't vote twice"
      end
    end

    scenario 'cannot see voting options for their own question' do
      sign_in(question.author)
      expect(page).to_not have_selector(:link_or_button, 'Like')
      expect(page).to_not have_selector(:link_or_button, 'Dislike')
    end
  end

  describe 'unauthenticated user', js: true do
    scenario 'cannot see voting options' do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Like')
      expect(page).to_not have_selector(:link_or_button, 'Dislike')
    end
  end
end
