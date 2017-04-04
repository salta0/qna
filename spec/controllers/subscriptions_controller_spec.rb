require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    sign_in_user
    let(:question) { create :question }
    let(:subscribed_question) { create :question, user: @user}
    let!(:subscription) { create :subscription, question: subscribed_question, user: @user }

    it 'create subscription, that belongs to question' do
      expect { post :create, question_id: question, format: :js }.to change(question.subscriptions, :count).by(1)
    end

    it 'create subscription, that belongs to user' do
      expect { post :create, question_id: question, format: :js }.to change(@user.subscriptions, :count).by(1)
    end

    it 'does not subscribe subscribed user' do
      expect { post :create, question_id: subscribed_question, format: :js }.to_not change(@user.subscriptions, :count)
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:question) { create :question }
    let!(:subscription) { create :subscription, question: question, user: @user }

    it "delete subscription" do
      expect { delete :destroy, question_id: question, id: subscription, format: :js }.to change(Subscription, :count).by(-1)
    end
  end
end
