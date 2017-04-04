require_relative "../acceptance_helper"

feature 'Delete answers files', %q{
  In order to delete answers files
  as author of answer
  i want be able to delete files
} do
    given(:user){ create (:user) }
    given!(:question) { create :question }
    given!(:answer) { create :answer, question: question, user: user }
    given!(:others_answer) { create :answer, question: question }
    given!(:attachment) { create(:attachment, attachable: answer) }
    given!(:others_attachment) { create(:attachment, attachable: others_answer) }

    scenario 'user try to delete thier files', js: true do
      sign_in(user)
      visit question_path(question)
      within "#answer-#{answer.id}" do
        page.find(:css, 'a[class="answer-attachments-link glyphicon glyphicon-file"]').click
        within '.attachments' do
          page.find(:css, 'a[class="glyphicon glyphicon-trash"]').click
          expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        end
      end
    end

    scenario 'non-authenticated user try to delete files', js: true do
      visit question_path(question)
      within '.answers' do
        page.all(:css, 'a[class="answer-attachments-link glyphicon glyphicon-file"]')[0].click
        expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
      end
    end

    scenario 'user try to delete others files', js: true do
      visit question_path(question)
      within "#answer-#{others_answer.id}" do
        page.find(:css, 'a[class="answer-attachments-link glyphicon glyphicon-file"]').click
        within '.attachments' do
          expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
        end
      end
    end
  end