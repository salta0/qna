require_relative "../acceptance_helper"

feature "edit user" do
  given(:user) { create :user }
  given(:another_user) { create :user }

  context "as authenticated user" do
    before { sign_in user }

    scenario "authenticated user can edit their profile", js: true do
      visit user_path(user)
      click_on "Редактировать профиль"
      fill_in "Имя", with: "Иван"
      fill_in "Откуда", with: "Москва"
      fill_in "О себе", with: "Небольшое описание"
      click_on "Сохранить"

      expect(page).to have_content "Иван"
      expect(page).to have_content "Москва"
      expect(page).to have_content "Небольшое описание"
    end

    scenario "authenticated user try to update their profile with blank name", js: true do
      visit user_path(user)
      click_on "Редактировать профиль"
      fill_in "Имя", with: ""
      fill_in "Откуда", with: "Москва"
      fill_in "О себе", with: "Небольшое описание"
      click_on "Сохранить"

      expect(page).to have_content "Обязательно к заполнению"
    end

    scenario "user try to edit others profile" do
      visit user_path(another_user)

      expect(page).to_not have_link "Редактировать профиль"
    end
  end

  scenario "non-authenticated user try to edit profile" do
    visit user_path(user)

    expect(page).to_not have_link "Редактировать профиль"
  end
end
