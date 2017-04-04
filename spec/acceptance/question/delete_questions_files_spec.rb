require_relative "../acceptance_helper"

feature 'Delete files to question', %q{
  In order to delete question
  as author of question
  i want be able to delete files
} do
    given(:user){ create (:user) }
    given!(:question) { create :question, user: user }
    given!(:others_question) { create :question }
    given!(:attachment) { create(:attachment, attachable: question) }
    given!(:others_attachment) { create(:attachment, attachable: others_question) }

    scenario 'user try to delete thier files', js: true do
      sign_in(user)
      visit question_path(question)
      within '.question' do
        page.find(:css, 'a[class="glyphicon glyphicon-file"]').click
        within '.attachments' do
          page.find(:css, 'a[class="glyphicon glyphicon-trash"]').click

          expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        end
      end
    end

    scenario 'non-authenticated user try to delete files', js: true do
      visit question_path(question)
      within '.question' do
        page.find(:css, 'a[class="glyphicon glyphicon-file"]').click
        within '.attachments' do
          expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
        end
      end
    end

    scenario 'user try to delete others files', js: true do
      visit question_path(others_question)
      within '.question' do
        page.find(:css, 'a[class="glyphicon glyphicon-file"]').click
        within '.attachments' do
          expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
        end
      end
    end
  end