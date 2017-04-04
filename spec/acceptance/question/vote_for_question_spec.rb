require_relative "../acceptance_helper"

feature 'vote for question', %q{
  in order to evaluate the use of question
  as an authenticated user
  i want to be able vote for question
} do

  given(:user) { create  :user }
  given!(:question) { create :question }
  given!(:own_question) { create :question, user: user}
  given!(:voted_question) { create :question}
  given!(:vote) { create :vote, user: user, votable: voted_question}

  context 'An authentificated user' do
    background do
        sign_in(user)
        visit question_path(question)
      end

    scenario 'see count of votes' do
      expect(page).to have_content question.rating
    end

    scenario 'user give a positive evaluation for question', js: true do
      within '.question' do
        page.find('.button-up').click

        within '.questions-rating' do
          expect(page).to have_content '1'
        end
        expect(page).to_not have_css 'a[class="button button-up glyphicon glyphicon-chevron-up"]'
        expect(page).to_not have_css 'a[class="button button-down glyphicon glyphicon-chevron-down"]'
        expect(page).to_not have_link 'Переголосовать'
      end
    end

    scenario 'user give a negative evaluation for question', js: true do
      within ".question" do
        page.find('.button-down').click

        within '.questions-rating' do
          expect(page).to have_content '-1'
        end
        expect(page).to_not have_css 'a[class="button button-up glyphicon glyphicon-chevron-up"]'
        expect(page).to_not have_css 'a[class="button button-down glyphicon glyphicon-chevron-down"]'
        expect(page).to_not have_link 'Переголосовать'
      end
    end

    scenario 'user cancle a vote for question', js: true do
      visit question_path(voted_question)

      within ".questions-rating" do
        expect(page).to have_content '1'
      end

      page.execute_script %($('.voting').mouseenter())
      click_on 'Переголосовать'

      within ".questions-rating" do
        expect(page).to have_content '0'
      end

      expect(page).to have_css 'a[class="button button-up glyphicon glyphicon-chevron-up"]'
      expect(page).to have_css 'a[class="button button-down glyphicon glyphicon-chevron-down"]'
      expect(page).to_not have_link 'Переголосовать'
    end

    scenario 'user try vote for own question' do
      visit question_path(own_question)
      within '.question' do
        expect(page).to have_content question.rating
        expect(page).to_not have_css 'a[class="button button-up glyphicon glyphicon-chevron-up"]'
        expect(page).to_not have_css 'a[class="button button-down glyphicon glyphicon-chevron-down"]'
        expect(page).to_not have_link 'Переголосовать'
      end
    end
  end

  context 'An non-authentificated user' do
    scenario 'try vote for question' do
      visit question_path(question)
      within '.question' do
        expect(page).to_not have_css 'a[class="button button-up glyphicon glyphicon-chevron-up"]'
        expect(page).to_not have_css 'a[class="button button-down glyphicon glyphicon-chevron-down"]'
        expect(page).to_not have_link 'Переголосовать'
      end
    end
  end
end
