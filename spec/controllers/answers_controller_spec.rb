require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:others_user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:others_answer) { create(:answer, question: question, body: 'body') }
  let(:user_question) { create(:question, user: @user) }
  let(:q_answer) { create(:answer, question: user_question) }
  let(:vote) { create(:vote, user: @user, votable: others_answer) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the answer in the database' do
       expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end
      it 'answer belongs to user' do
       expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(@user.answers, :count).by(1)
      end
      it 'render create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
      it 'render create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    it 'assings the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns th question' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body'}, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it "doesn't change others answer" do
      patch :update, id: others_answer, answer: { body: 'new body'}, format: :js
      others_answer.reload
      expect(others_answer.body).to eq 'body'
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
      sign_in_user
      it 'delete thier answer' do
        answer
        expect { delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end
      
      it 'not delete others_answer' do
        others_answer
        expect { delete :destroy, id: others_answer, format: :js }.to_not change(Answer, :count)
      end

      it 'render destroy' do
        delete :destroy, id: answer, format: :js
        expect(response).to render_template :destroy
      end
  end

  describe 'PATCH #set_best' do
    sign_in_user

    it 'autor of question set best answer' do
      patch :set_best, id: q_answer, question_id: user_question, format: :js
      q_answer.reload
      expect(q_answer.best).to eq true
    end

    it 'render set_best' do
      patch :set_best, id: q_answer, question_id: user_question, format: :js
      expect(response).to render_template :set_best
    end

    it "doesn't set best answer to others question" do
      expect { patch :set_best, id: answer, question_id: question, format: :js }.to_not change(answer, :best)
    end
  end

  describe "PATCH #vote_up" do
    it_behaves_like "Change Votable" do
      let(:object) { others_answer }
      let(:own_object) { answer }
      let(:type) { :patch }
      let(:action) { :vote_up }
      let(:result) { 1 }
    end
  end

  describe "PATCH #vote_down" do
    let(:object) { others_answer }
    let(:own_object) { answer }
    let(:type) { :patch }
    let(:action) { :vote_down }
    let(:result) { -1 }
    it_behaves_like "Change Votable"
  end

  describe "DELETE #vote_reset" do
    let(:object) { others_answer }
    it_behaves_like "Reset Votable"
  end
end