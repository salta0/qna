require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let!(:question) { create :question, user: user }
    let!(:answer) { create :answer, question: question }
    let(:mail) { NotificationMailer.answer_notification(user, answer) }


    it 'renders the headers' do
      expect(mail.subject).to eq("Answer notification")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hi #{user.email}")
      expect(mail.body.encoded).to match(question.title)
    end
  end
end
