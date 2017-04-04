require_relative "../acceptance_helper"

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I'd like ot be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:others_question) { create(:question) }

  scenario 'Non-authenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Редактировать'
  end


  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      expect(page).to have_css 'a[class="edit-question-link glyphicon glyphicon-pencil"]'
    end

    scenario 'try to edit his question', js: true do
      within '.question' do
        page.find(:css, 'a[class="edit-question-link glyphicon glyphicon-pencil"]').click
        fill_in 'Тема', with: 'edited title'
        fill_in 'Проблема', with: 'edited problem'
        click_on 'Сохранить'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited problem'
        expect(page).to_not have_selector '#question-title'
        expect(page).to_not have_selector '#question-body'
      end
    end

    scenario "try to update with blank question", js: true do
      within '.question' do
        page.find(:css, 'a[class="edit-question-link glyphicon glyphicon-pencil"]').click
        fill_in 'Тема', with: ''
        fill_in 'Проблема', with: ''
        click_on 'Сохранить'

        expect(page).to have_content 'Вопрос не может быть пустым'
      end
    end
    
    scenario "try to edit other user's question", js: true do
      visit question_path(others_question)
      within '.question' do
        expect(page).to_not have_css 'a[class="edit-question-link glyphicon glyphicon-pencil"]'
      end
    end
  end
end