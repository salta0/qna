require_relative "../acceptance_helper"

feature 'Siging in', %q{
  In order to be able ask questions
  As an user
  I want be able to sign in
 } do

  given(:user) { create(:user) }

  scenario "Existing user try to sign in" do
    sign_in(user)

    expect(page).to have_content 'Вход в систему выполнен.'
  end

  scenario 'Non-existing user try to sign in' do
    visit new_user_session_path
    fill_in 'E-mail', with: 'wrong@user.com'
    fill_in 'Пароль', with: '12345'
    click_on 'Войти'

    expect(page).to have_content 'Неверный email или пароль.'
  end
end
