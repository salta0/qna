require_relative "../acceptance_helper"

feature "user can view profile" do
  given!(:user) { create :user }

  scenario "user view own profile" do
    sign_in user
    visit root_path
    click_on "Мой профиль"

    expect(page).to have_link "Редактировать профиль"
    expect(page).to have_link "Настройки аккаунта"
    expect(page).to have_content user.name
    expect(page).to have_content user.location
    expect(page).to have_content user.description
  end

  scenario "user view profile" do
    visit users_path
    # save_and_open_page
    click_on user.name

    expect(page).to_not have_link "Редактировать профиль"
    expect(page).to_not have_link "Настройки аккаунта"
    expect(page).to have_content user.name
    expect(page).to have_content user.location
    expect(page).to have_content user.description
  end
end
