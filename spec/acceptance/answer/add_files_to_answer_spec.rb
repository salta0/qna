require_relative "../acceptance_helper"

feature 'Add files to answer', %q{
  In order to illustrate answer
  as an author of answer
  i want to be able add files to answer
} do

  given(:user){ create (:user) }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'user add file when сreate answer', js: true do
      within '.answer-form' do
        fill_in 'Ваш ответ', with: 'answer'
        click_on 'Добавить'
        page.all(:css, 'input[type="file"]').first.set("#{Rails.root}/spec/spec_helper.rb")
        page.all(:css, 'input[type="file"]')[1].set("#{Rails.root}/spec/rails_helper.rb")
        click_on 'Ответить'
      end

      within '.answers' do
        page.all(:css, 'a[class="answer-attachments-link glyphicon glyphicon-file"]')[1].click

        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end

    scenario 'user add files to created answer', js: true do
      visit question_path(question)
      within "#answer-#{answer.id}" do
        page.find(:css, 'a[class="answer-attachments-link glyphicon glyphicon-file"]').click
        page.all(:css, 'input[type="file"]').first.set("#{Rails.root}/spec/spec_helper.rb")
        click_on 'Добавить'
        page.all(:css, 'input[type="file"]')[1].set("#{Rails.root}/spec/rails_helper.rb")
        click_on 'Прикрепить'
        page.find(:css, 'a[class="answer-attachments-link glyphicon glyphicon-file"]').click

        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end

    scenario 'user delete attached files when сreate answer', js: true do
      within '.answer-form' do
        fill_in 'Ваш ответ', with: 'text text text'
        click_on 'Добавить'
        page.all(:css, 'input[type="file"]').first.set("#{Rails.root}/spec/spec_helper.rb")
        page.all(:css, 'input[type="file"]')[1].set("#{Rails.root}/spec/rails_helper.rb")
        page.find(:css, 'a[class="remove_fields dynamic"]', match: :first).click
        click_on 'Ответить'
      end

      within '.answers' do
        page.all(:css, 'a[class="answer-attachments-link glyphicon glyphicon-file"]')[1].click

        expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
      end
    end
end
