require_relative "../acceptance_helper"

feature 'Add files to question', %q{
	In order to illustrate question
	as author of question
	i want be able to attach files
} do
    given(:user){ create (:user) }
    given!(:question) { create :question, user: user }

    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'user add files when qreate question', js: true do
      fill_in 'Тема', with: 'Test question'
      fill_in 'Описание проблемы', with: 'text text text'
      click_on "Добавить"
      page.all(:css, 'input[type="file"]').first.set("#{Rails.root}/spec/spec_helper.rb")
      page.all(:css, 'input[type="file"]')[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on "Создать"
      page.find(:css, 'a[class="glyphicon glyphicon-file"]').click

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end

    scenario 'user add files to created question', js: true do
      visit question_path(question)
      within '.question' do
        page.find(:css, 'a[class="glyphicon glyphicon-file"]').click
        page.all(:css, 'input[type="file"]').first.set("#{Rails.root}/spec/spec_helper.rb")
        click_on 'Добавить'
        page.all(:css, 'input[type="file"]')[1].set("#{Rails.root}/spec/rails_helper.rb")
        click_on 'Прикрепить'
        page.find(:css, 'a[class="glyphicon glyphicon-file"]').click

        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end

    scenario 'user delete attached files when qreate question', js: true do
      fill_in 'Тема', with: 'Test question'
      fill_in 'Описание проблемы', with: 'text text text'
      click_on "Добавить"
      page.all(:css, 'input[type="file"]').first.set("#{Rails.root}/spec/spec_helper.rb")
      page.all(:css, 'input[type="file"]')[1].set("#{Rails.root}/spec/rails_helper.rb")
      page.find(:css, 'a[class="remove_fields dynamic"]', match: :first).click
      click_on 'Создать'
      page.find(:css, 'a[class="glyphicon glyphicon-file"]').click

      expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
end
