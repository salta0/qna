require_relative "../acceptance_helper"

feature 'Delete comment from answer', %q{
  In order to delete comment
  as an user
  i want to be able delete comment
} do

  given(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create :answer, question: question }
  given!(:comment) { create :comment, commentable: answer, user: user }
  given!(:others_comment) { create :comment, commentable: answer }

  describe 'Authenticated user delete comment' do
    before do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Authenticated user delete own comment', js: true do
      within "#answer-#{answer.id}" do
        page.find(:css, 'a[class="answer-comments-link glyphicon glyphicon-comment"]').click
        page.find(:css, 'a[class="glyphicon glyphicon-trash"]').click

        expect(page).to_not have_content comment
      end
    end

    scenario 'User try to delete othes comment', js: true do
      within "#answer-#{answer.id}" do
        page.find(:css, 'a[class="answer-comments-link glyphicon glyphicon-comment"]').click
        within "#comment-#{others_comment.id}" do
          expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
        end
      end
    end
 end

  scenario 'Non-authenticated user try delete comment' do
    visit question_path(question)
    within "#answer-#{answer.id}" do
      page.find(:css, 'a[class="answer-comments-link glyphicon glyphicon-comment"]').click

      expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
    end
  end 
end
