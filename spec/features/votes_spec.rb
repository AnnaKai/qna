require 'rails_helper'

feature 'User can vote for questions/answers', %q(
  In order to show that I like question/answer
  As an authenticated user
  I'd like to be able to increase/decrease its rating
) do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user', js: true do
    context 'voting for others\' questions' do
      scenario 'votes for the question they like' do
        sign_in(user)
        visit question_path(question)
        expect(page.find('.rating')).to have_content '0'
        click_on 'Vote up'
        expect(page.find('.rating')).to have_content '1'
        visit question_path(question)
        expect(page.find('.rating')).to have_content '1'
      end

      scenario 'changes their vote' do
      end

      scenario 'downvotes a question' do
      end

      scenario 'sees overall rating' do
      end

      scenario 'tries to vote/downvote twice without success' do
      end
    end

    scenario 'cannot see voting options for their own question' do
      sign_in(question.author)
      expect(page).to_not have_selector(:link_or_button, 'Vote up')
      expect(page).to_not have_selector(:link_or_button, 'Vote down')
    end
  end

  describe 'unauthenticated user', js: true do
    scenario 'cannot see voting options' do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Vote up')
      expect(page).to_not have_selector(:link_or_button, 'Vote down')
    end
  end

end
