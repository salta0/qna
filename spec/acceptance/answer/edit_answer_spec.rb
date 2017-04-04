require_relative "../acceptance_helper"

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:others_answer) { create(:answer, question: question) }

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
      within '.answers' do
        expect(page).to have_link "edit-answer-link-#{answer.id}"
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on "edit-answer-link-#{answer.id}"
      within "#answer-#{answer.id}" do
        fill_in 'Ответ', with: 'edited answer'
        click_on 'Сохранить'
        expect(page).to_not have_selector '#answer_body'
      end
      within '.answers' do
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
      end
    end

    scenario 'try to edit with blank body', js: true do
      click_on "edit-answer-link-#{answer.id}"
      within "#answer-#{answer.id}" do
        fill_in 'Ответ', with: ''
        click_on 'Сохранить'

        expect(page).to have_content 'Ответ не может быть пустым'
      end
    end

    scenario "doesn't have link to edit others answer", js: true do
      within "#answer-#{others_answer.id}" do
        expect(page).to_not have_link "edit-answer-link-#{answer.id}"
      end
    end
  end
end