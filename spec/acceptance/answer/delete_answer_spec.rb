require_relative "../acceptance_helper"

feature 'Delete answer', %q{
  In order to delete answer
  as an user
  i want to be able delete answer
} do

  given(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create :answer, question: question, user: user  }
  given!(:others_answer) { create :answer, question: question  }

  before do 
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user try delete their answer', js: true do
    within "#answer-#{answer.id}" do
      page.find(:css, 'a[class="glyphicon glyphicon-trash"]').click
    end

    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user try to delete anothers answers', js: true do
    within "#answer-#{others_answer.id}" do
      expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
    end
  end
end