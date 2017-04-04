require_relative "../acceptance_helper"

feature 'Delete question', %q{
  In order to delete question
  as an user
  i want to be able delete question
} do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:others_question) { create :question}

  scenario 'Authenticated user try delete their question' do
    sign_in(user)
    visit question_path(question)
    page.find(:css, 'a[class="glyphicon glyphicon-trash"]').click
    
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user try to delete others question' do
    sign_in(user)
    visit question_path(others_question)
    
    expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
  end
end