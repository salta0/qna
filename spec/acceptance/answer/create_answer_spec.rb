require_relative "../acceptance_helper"

feature 'Create answer', %q{
  In order to help other user
  as an user
  i want to be able ansewr to question
} do

  given!(:user) { create :user }
  given!(:question) { create(:question) }

  describe 'Authenticated user create answer' do
    before do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Authenticated user create answer', js: true do
      fill_in 'Ваш ответ', with: 'text text'
      click_on 'Ответить'
      
      expect(page).to have_content 'text text'
    end

     scenario 'User try to create answer with blank body', js: true do
      fill_in 'Ваш ответ', with: ''
      click_on 'Ответить'

      expect(page).to have_content 'Ответ не может быть пустым'
     end
 end

  scenario 'Non-authenticated user create answer' do
    visit question_path(question)
    expect(page).to_not have_css '.answer-form'
  end
end