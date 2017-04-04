require_relative "../acceptance_helper"

feature 'Delete comment from question', %q{
  In order to delete comment
  as an user
  i want to be able add delete comment
} do

  given!(:user) { create :user }
  given!(:question) { create :question }
  given!(:comment) { create :comment, commentable: question, user: user }
  given!(:others_comment) { create :comment, commentable: question }

  describe 'Authenticated user delete comment' do
    before do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Authenticated user delete own comment', js: true do
      within ".question" do
        page.find(:css, 'a[class="glyphicon glyphicon-comment"]').click
        within "#comment-#{comment.id}" do
          page.find(:css, 'a[class="glyphicon glyphicon-trash"]').click

          expect(page).to_not have_content comment
        end
      end
    end

    scenario 'User try to delete others comment', js: true do
      within '.question' do
        page.find(:css, 'a[class="glyphicon glyphicon-comment"]').click
        within "#comment-#{others_comment.id}" do
          expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
        end
      end
    end
  end

  scenario 'Non-authenticated user try to delete comment' do
    visit question_path(question)

    within '.question' do
      page.find(:css, 'a[class="glyphicon glyphicon-comment"]').click

      expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
    end
  end
end 