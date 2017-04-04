require_relative "../acceptance_helper"

feature 'Show question with its answers', %q{
  In order to see ansewrs the question
  as an user
  i want to be able see the list of answers
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Users can view question with answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end