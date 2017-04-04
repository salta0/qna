require_relative "../acceptance_helper"

feature 'Siging in', %q{
  In order to be able sign in with social network account
  As an user
  I want be able to sign in with social network account
 } do

  before do 
      mock_auth_hash(:facebook)
      visit new_user_session_path
  end

  describe 'exist user with bound account' do
    given(:user) { create :user }
    given!(:authorization) { create :authorization, user: user, provider: mock_auth_hash(:facebook)['provider'], uid: mock_auth_hash(:facebook)['uid'] }
    scenario 'try to sign in' do
      user.confirm
      click_on 'Войти с помощью Facebook'
      expect(page).to have_content 'Вход в систему выполнен с учётной записью из Facebook'
    end
  end

  describe 'existing user try sign in' do
    given(:user) { create :user, email: 'new@user.com' }
    scenario 'existing user try sign in' do
      user.confirm
      click_on 'Войти с помощью Facebook'
      expect(page).to have_content 'Вход в систему выполнен с учётной записью из Facebook.'
    end
  end

  scenario 'not existing user try sign in' do
    click_on 'Войти с помощью Facebook'
    expect(page).to have_content 'Вы должны подтвердить Ваш адрес электронной почты.'
  end

  scenario 'with invalid credentials' do
    visit new_user_session_path
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    click_on 'Войти с помощью Facebook'
    expect(page).to have_content "Вы не можете войти в систему с учётной записью из Facebook, так как \"Invalid credentials\"."
  end
end