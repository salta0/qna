require_relative "../acceptance_helper"

feature 'Show list of questions', %q{
  In order to find question
  as an user
  i want to be able see the list of questions
} do

  given!(:questions) { create_list(:question, 2) }

    scenario 'User view questions' do
      visit root_path
      questions.each do |q|
          expect(page).to have_content q.title
      end
    end
  end