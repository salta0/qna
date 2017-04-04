require_relative "../acceptance_helper"

feature 'Log out', %q{
  In order to destroy session
  As an user
  I want be able to log out
 } do

  given(:user) { create(:user) }
  
  scenario "Existing user try to log out" do
    sign_in(user)
    click_on 'Выйти'
    expect(page).to have_content 'Выход из системы выполнен.'
  end

  scenario "Non-existing user try to log out" do
    visit root_path
    expect(page).to_not have_content 'Выйти'
  end
end