module AcceptanceHelper
  def sign_in(user)
    user.confirm
    visit new_user_session_path
    fill_in 'E-mail', with: user.email
    fill_in 'Пароль', with: user.password
    click_on 'Войти'
  end
end
