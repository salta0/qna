require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create :question }
  let!(:subscription) { create :subscription, user: user, question: question }
  let!(:answer) { create :answer, question: question }

  it 'send notification' do
    question.subscriptions.each do |subscription|
      expect(NotificationMailer).to receive(:answer_notification).with(subscription.user, answer).and_call_original 
    end

    AnswerNotificationJob.perform_now(answer)
  end
end
