require_relative "../acceptance_helper"

feature 'Add comment to answer', %q{
  In order to comment answer
  as an user
  i want to be able add comment to answer
} do

  given(:user) { create :user }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user add comment' do
    before do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Authenticated user add comment', js: true do
      within "#answer-#{answer.id}" do
        page.find(:css, 'a[class="answer-comments-link glyphicon glyphicon-comment"]').click
        fill_in 'comment_body', with: "comment"
        click_on "Комментировать"

        expect(page).to have_content 'comment'
      end
    end

    scenario 'User try to add comment with blank body', js: true do
      within "#answer-#{answer.id}" do
        page.find(:css, 'a[class="answer-comments-link glyphicon glyphicon-comment"]').click
        fill_in 'comment_body', with: ''
        click_on "Комментировать"

        expect(page).to have_content 'Комментарий не может быть пустым'
      end
    end
 end

scenario 'Non-authenticated user add comment' do
    visit question_path(question)
    within "#answer-#{answer.id}" do
      page.find(:css, 'a[class="answer-comments-link glyphicon glyphicon-comment"]').click
      expect(page).to_not have_css 'textarea[id="comment_body"]'
    end
  end
end 