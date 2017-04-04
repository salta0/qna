require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: @user) }
  let(:others_question) { create(:question, title: 'title', body: 'body') }
  let(:vote) { create(:vote, user: @user, votable: others_question) }


  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get :show, id: question }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the question, that belongs to user, in the database' do
       expect { post :create, user_id: user, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end


  describe 'PATCH #update' do
    sign_in_user

    it 'assings the requested question to @question' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      patch :update, id: question, question: { title: 'new title', body: 'new body'}, format: :js
      question.reload
      expect(question.title).to eq 'new title'
      expect(question.body).to eq 'new body'
    end

    it "doesn't change others question" do
      patch :update, id: others_question, question: { title: 'new title', body: 'new body'}, format: :js
      others_question.reload
      expect(others_question.title).to eq "title"
      expect(others_question.body).to eq "body"
    end

    it 'render update template' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'Authenticated user delete their question' do
      let(:question) { create(:question, user: @user) }

      it 'delete the question' do
        question
        expect { delete :destroy, id: question }.to change(@user.questions, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, id: question
        expect(response).to redirect_to '/questions'
      end
    end

    context 'Authenticated user delete others question' do
      let(:question) { create(:question) }

      it 'doesnt delete the question' do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end
      it 'redirects to root' do
        delete :destroy, id: question
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "PATCH #vote_up" do
    let(:object) { others_question }
    let(:own_object) { question }
    let(:type) { :patch }
    let(:action) { :vote_up }
    let(:result) { 1 }
    it_behaves_like "Change Votable"
  end

  describe "PATCH #vote_down" do
    let(:object) { others_question }
    let(:own_object) { question }
    let(:type) { :patch }
    let(:action) { :vote_down }
    let(:result) { -1 }
    it_behaves_like "Change Votable"
  end

  describe "DELETE #vote_reset" do
    let(:object) { others_question }
    it_behaves_like "Reset Votable"
  end
end
