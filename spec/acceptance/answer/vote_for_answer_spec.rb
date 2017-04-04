require_relative "../acceptance_helper"

feature 'vote for answer', %q{
  in order to evaluate the use of answer
  as an authenticated user
  i want to be able vote for answer
} do

  given(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create :answer, question: question }
  given!(:own_answer) { create :answer, question: question, user: user }
  given!(:voted_answer) { create :answer, question: question }
  given!(:vote) { create :vote, user: user, votable: voted_answer}

  context 'An authenticated user' do
    background do
        sign_in(user)
        visit question_path(question)
      end

    scenario 'see count of votes' do
      within "#answer-#{answer.id}" do
        expect(page).to have_content answer.rating
      end
    end

    scenario 'user give a positive evaluation for answer', js: true do
      within "#answer-#{answer.id}" do
        find('a[class="button button-up glyphicon glyphicon-chevron-up"]').click

        within ".answers-rating" do
          expect(page).to have_content '1'
        end
        expect(page).to_not have_css 'a[class="button button-up glyphicon glyphicon-chevron-up"]'
        expect(page).to_not have_css 'a[class="button button-down glyphicon glyphicon-chevron-down"]'
        expect(page).to_not have_content 'Переголосовать'
      end
    end

    scenario 'user give a negative evaluation for answer', js: true do
      within "#answer-#{answer.id}" do
        find('a[class="button button-down glyphicon glyphicon-chevron-down"]').click

        within ".answers-rating" do
          expect(page).to have_content '-1'
        end
        expect(page).to_not have_css 'a[class="button button-up glyphicon glyphicon-chevron-up"]'
        expect(page).to_not have_css 'a[class="button button-down glyphicon glyphicon-chevron-down"]'
        expect(page).to_not have_link 'Переголосовать'
      end
    end

    scenario 'user cancle a vote for answer', js: true do
      within "#answer-#{voted_answer.id}" do
        within ".answers-rating" do
          expect(page).to have_content '1'
        end

        page.execute_script %($('.voting').mouseenter())
        click_on "Переголосовать"

        within ".answers-rating" do
          expect(page).to have_content '0'
        end

        expect(page).to have_css 'a[class="button button-up glyphicon glyphicon-chevron-up"]'
        expect(page).to have_css 'a[class="button button-down glyphicon glyphicon-chevron-down"]'
        expect(page).to_not have_link 'Переголосовать'
      end
    end

    scenario 'user try vote for own answer', js: true do
      within "#answer-#{own_answer.id}" do
        expect(page).to_not have_css 'a[class="button button-up glyphicon glyphicon-chevron-up"]'
        expect(page).to_not have_css 'a[class="button button-down glyphicon glyphicon-chevron-down"]'
        expect(page).to_not have_link 'Переголосовать'
      end
    end
  end

  context 'An non-authenticated user' do
    scenario 'user try voting for answer' do
      visit question_path(question)
      within "#answer-#{answer.id}" do
        expect(page).to have_content answer.rating

        expect(page).to_not have_css 'a[class="button button-up glyphicon glyphicon-chevron-up"]'
        expect(page).to_not have_css 'a[class="button button-down glyphicon glyphicon-chevron-down"]'
        expect(page).to_not have_link 'Переголосовать'
      end
    end
  end
end
