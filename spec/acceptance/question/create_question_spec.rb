require_relative "../acceptance_helper"

feature 'Create question', %q{
  In order to get answer
  as an user
  i want to be able ask question
} do
  given!(:user) { create :user }

  scenario 'Authenticated user create question' do
    sign_in(user)

    visit root_path
    click_on 'Задать вопрос'
    fill_in 'Тема', with: 'Test question'
    fill_in 'Описание проблемы', with: 'text text'
    click_on 'Создать'

    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'
  end

  scenario 'Non-authenticated user create question' do
    visit root_path
    expect(page).to_not have_content "Задать вопрос"
  end
end
