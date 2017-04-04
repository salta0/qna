require_relative "../acceptance_helper"

feature 'Registration', %q{
  In order to able use services of app
  As an user
  I want be able sign up
 } do

  given!(:user) { create(:user) }

  scenario 'Non-existing user try to sign up' do
    visit new_user_registration_path
    fill_in 'E-mail', with: 'user@user.com'
    fill_in 'Пароль', with: 'sdfsfцфыва'
    fill_in 'Подтверждение пароля', with: 'sdfsfцфыва'
    click_on 'Зарегистрироваться'

    expect(page).to have_content 'На Ваш адрес электронной почты было отправлено сообщение с инструкциями по подтверждению Вашей учётной записи. Пожалуйста, проследуйте по ссылке из этого письма для активации Вашей учетной записи.'
    expect(current_path).to eq root_path
  end

  scenario "User try to sign up with invalid email and password" do
    visit new_user_registration_path
    fill_in 'E-mail', with: 'not_email'
    fill_in 'Пароль', with: '123'
    fill_in 'Подтверждение пароля', with: '456'
    click_on 'Зарегистрироваться'

    expect(page).to have_content 'E-mailимеет неверное значение'
  end

  scenario "Existing user try to sign up" do
    visit new_user_registration_path
    fill_in 'E-mail', with: user.email
    fill_in 'Пароль', with: user.password
    fill_in 'Подтверждение пароля', with: user.password
    click_on 'Зарегистрироваться'

    expect(page).to have_content 'E-mailуже существует'
  end
end
