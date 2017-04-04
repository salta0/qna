require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: @user) }
  let(:others_question) { create :question }
  let(:answer) { create :answer, user: @user }
  let(:others_answer) { create :answer }
  let(:question_attachment) { create :attachment, attachable: question }
  let(:answer_attachment) { create :attachment, attachable: answer }
  let(:others_question_attachment) { create :attachment, attachable: others_question }
  let(:others_answer_attachment) { create :attachment, attachable: others_answer }


  describe 'DELETE #destroy' do
    context "delete question's files" do
      sign_in_user
      it 'delete the file' do
        question_attachment
        expect { delete :destroy, id: question_attachment, format: :js }.to change(Attachment, :count).by(-1)
      end

      it "doesn't delete the others file" do
        others_question_attachment
        expect { delete :destroy, id: others_question_attachment, format: :js }.to_not change(Attachment, :count)
      end

      it 'render destroy' do
        delete :destroy, id: question_attachment, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "delete answer's files" do
      sign_in_user
      it 'delete the file' do
        answer_attachment
        expect { delete :destroy, id: answer_attachment, format: :js }.to change(Attachment, :count).by(-1)
      end

      it "doesn't delete the others file" do
        others_answer_attachment
        expect { delete :destroy, id: others_answer_attachment, format: :js }.to_not change(Attachment, :count)
      end

      it 'render destroy' do
        delete :destroy, id: question_attachment, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
