require_relative "../acceptance_helper"

feature 'Set best answer', %q{
  In order to other users see more useful answer
  As an author of question
  I'd like be able to set best answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:others_question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:others_answers) { create(:answer, question: others_question) }

  scenario 'Non-authenticated user try to set best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Лучший ответ'
  end


  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to Лучший ответ' do
      expect(page).to have_css 'a[class="best-answer-link glyphicon glyphicon-ok"]'
    end

    scenario 'try to set best answer', js: true do
      page.find(:css, 'a[class="best-answer-link glyphicon glyphicon-ok"]').click

      expect(page).to have_css 'span[class="glyphicon glyphicon-ok-circle"]'
      expect(page).to_not have_css 'a[class="best-answer-link glyphicon glyphicon-ok"]'
    end

    scenario "try to set best answer to others user's question", js: true do
      visit question_path(others_question)
      expect(page).to_not have_css 'a[class="best-answer-link glyphicon glyphicon-ok"]'
    end
  end
end