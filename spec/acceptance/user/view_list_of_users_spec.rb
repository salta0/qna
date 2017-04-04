require_relative "../acceptance_helper"

feature "view list of users" do
  given!(:users) { create_list :user, 3 }
  scenario "all users and guests can view list of user's profile" do
    visit root_path
    click_on "Пользователи"

    users.each do |user|
      expect(page).to have_link user.name
    end
  end
end
