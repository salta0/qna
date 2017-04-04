require_relative "../acceptance_helper"

feature 'Subscribe for a question', %q{
  In order to get mail notification
  as an user
  i want to be able subscribe to a question
} do

  given(:user) { create :user }
  given!(:question) { create :question }
  given!(:subscribed_question) { create :question, user: user }  

  describe "authenticated user" do
    before { sign_in(user) }  

    scenario "user subscribe for question", js: true do
      visit question_path(question)
      page.find(:css, 'a[class="subscribe-link glyphicon glyphicon-star-empty"]').click

      expect(page).to have_css 'a[class="unsubscribe-link glyphicon glyphicon-star"]'
      expect(page).to_not have_css 'a[class="subscribe-link glyphicon glyphicon-star-empty"]'
    end

    scenario "subscribed user try subscribe for question" do
      visit question_path(subscribed_question)
      expect(page).to_not have_css 'a[class="subscribe-link glyphicon glyphicon-star"]'
    end

    scenario "user unsubscribe for question", js: true do
      visit question_path(subscribed_question)
      page.find(:css, 'a[class="unsubscribe-link glyphicon glyphicon-star"]').click

      expect(page).to have_css 'a[class="subscribe-link glyphicon glyphicon-star-empty"]'
      expect(page).to_not have_css 'a[class="unsubscribe-link glyphicon glyphicon-star"]'
    end
  end

  scenario "non-authenticated user try subscribe for question" do
    visit question_path(question)

    expect(page).to_not have_css 'a[class="subscribe-link glyphicon glyphicon-star"]'
    expect(page).to_not have_css 'a[class="unsubscribe-link glyphicon glyphicon-star"]'
  end
end