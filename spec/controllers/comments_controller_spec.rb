require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }

   describe 'POST #create' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the comment in the database' do
         expect { post :create, question_id: question, commentable: question, comment: attributes_for(:comment), format: :js }.to change(question.comments, :count).by(1)
         expect { post :create, answer_id: answer, commentable: answer, comment: attributes_for(:comment), format: :js }.to change(answer.comments, :count).by(1)
        end

        it 'comment belongs to user' do
         expect { post :create, question_id: question, commentable: question, comment: attributes_for(:comment), format: :js }.to change(@user.comments, :count).by(1)
         expect { post :create,  answer_id: answer, commentable: answer, comment: attributes_for(:comment), format: :js }.to change(@user.comments, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, question_id: question, commentable: question, comment: attributes_for(:invalid_comment), format: :js }.to_not change(Comment, :count)
          expect { post :create, answer_id: answer, commentable: answer,comment: attributes_for(:invalid_comment), format: :js }.to_not change(Comment, :count)
        end
      end
   end

   describe 'DELETE #destroy' do
      let!(:others_answer_comment) { create :comment, commentable: answer }
      let!(:others_question_comment) { create :comment, commentable: question }


      context 'authorized user' do
        sign_in_user

        let!(:answer_comment) { create :comment, commentable: answer, user: @user }
        let!(:question_comment) { create :comment, commentable: question, user: @user }
    
        it 'delete own comment' do
          expect { delete :destroy, id: question_comment, format: :js }.to change(question.comments, :count).by(-1)
          expect { delete :destroy, id: answer_comment, format: :js }.to change(answer.comments, :count).by(-1)
        end

        it 'does not delete others comment' do
          expect { delete :destroy, id: others_question_comment, format: :js }.to_not change(Comment, :count)
          expect { delete :destroy, id: others_answer_comment, format: :js }.to_not change(Comment, :count)
        end
      end

      context 'non-authorized user' do
        it 'does not delete others comment' do
          expect { delete :destroy, id: others_question_comment, format: :js }.to_not change(Comment, :count)
          expect { delete :destroy, id: others_answer_comment, format: :js }.to_not change(Comment, :count)
        end
      end
   end
end