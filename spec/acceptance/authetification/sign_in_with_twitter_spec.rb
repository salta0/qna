require_relative "../acceptance_helper"

feature 'Siging in with Twitter', %q{
  In order to be able sign in with Twitter
  As an user
  I want be able to sign in with Twitter
 } do

  before do
   mock_auth_hash(:twitter) 
   visit new_user_session_path
  end

  given(:user) { create(:user) }

  describe 'exist user with bound account' do
    given!(:authorization) { create :authorization, user: user, provider: mock_auth_hash(:twitter)['provider'], uid: mock_auth_hash(:twitter)['uid'] }
    scenario 'try to sign in' do
      user.confirm
      click_on 'Войти с помощью Twitter'
      expect(page).to have_content 'Вход в систему выполнен с учётной записью из Twitter'
    end
  end

  scenario 'exist user try sign in' do
    user.confirm
    mock_auth_hash(:twitter)
    click_on 'Войти с помощью Twitter'
    fill_in 'Email', with: user.email
    click_on 'Продолжить'
    expect(page).to have_content "Аккаунт успешно привязан к вашей учетной записи. Теперь вы можете входить в систему с помощью Twitter."
  end

  scenario 'not exist user try sign in' do
    click_on 'Войти с помощью Twitter'
    fill_in 'Email', with: 'test@test.com'
    click_on 'Продолжить'
    expect(page).to have_content 'Вы должны подтвердить Ваш адрес электронной почты.'
  end

  scenario 'with invalid credentials' do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    click_on 'Войти с помощью Twitter'
    expect(page).to have_content "Вы не можете войти в систему с учётной записью из Twitter, так как \"Invalid credentials\"."
  end

  scenario 'with invalid email' do
    click_on 'Войти с помощью Twitter'
    fill_in 'Email', with: 'invalid'
    click_on 'Продолжить'
    expect(page).to have_content 'Email имеет неверное значение'
  end
end