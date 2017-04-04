require_relative "./acceptance_helper"
require_relative "./sphinx_helper"

feature 'Search', %q{
  In order to able find anything
  As an user
  I want be able search
 } do

  given!(:user1) { create :user, name: "Ivan" }
  given!(:user2) { create :user, name: "Sergey" }
  given!(:questions) { create_list :question, 2 }
  given!(:answers) { create_list :answer, 2 }
  given!(:comments) { create_list :comment, 2, commentable: questions.first }

  before do
    index
    visit root_path
  end

  scenario 'user try find user', js: true do
    fill_in "query", with: user1.name
    select "пользователям", from: "subject"
    page.find(:css, 'button[class="search-button glyphicon glyphicon-search"]').click
    expect(page).to have_link user1.name
    expect(page).to_not have_link user2.name
  end

  scenario 'user try find question', js: true do
    fill_in "query", with: questions.first.title
    select "вопросам", from: "subject"
    page.find(:css, 'button[class="search-button glyphicon glyphicon-search"]').click

    expect(page).to have_link questions.first.title
    expect(page).to have_content questions.first.body
    expect(page).to_not have_content questions.last.title
  end

  scenario 'user try find answer', js: true do
    fill_in "query", with: answers.first.body
    select "ответам", from: "subject"
    page.find(:css, 'button[class="search-button glyphicon glyphicon-search"]').click

    expect(page).to have_link answers.first.question.title
    expect(page).to have_content answers.first.body
    expect(page).to_not have_content answers.last.body
  end

  scenario 'user try find comment', js: true do
    fill_in "query", with: comments.first.body
    select "комментариям", from: "subject"
    page.find(:css, 'button[class="search-button glyphicon glyphicon-search"]').click

    expect(page).to have_link comments.first.commentable.title
    expect(page).to have_content comments.first.body
    expect(page).to_not have_content comments.last.body
  end
end
